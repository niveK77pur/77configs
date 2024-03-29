package device

import (
	"encoding/json"
	"errors"
	"fmt"
	"log/slog"
	"os/exec"
	"regexp"
)

type devicetype int

const (
	USB devicetype = iota
	MTP
)

func (dt devicetype) As_string() string {
	switch dt {
	case USB:
		return "USB"
	case MTP:
		return "MTP"
	default:
		return "???"
	}
}

// The high level block device
type BlockDevice struct {
	Path        string
	Size        string
	Label       string
	Mountpoints []string
	Children    []Device
}

// The actual mountable device (i.e. partition)
type Device struct {
	Path        string
	Size        string
	Label       string
	Mountpoints []string
	Hotplug     bool
	Kind        devicetype
}

func (device Device) Is_mounted() bool {
	if len(device.Mountpoints) == 1 && device.Mountpoints[0] == "" {
		// https://stackoverflow.com/q/35866221
		// An empty []string is not actually empty.
		// There will be a single empty string ("") inside.
		return false
	}
	return true
}

func (device Device) As_string() string {
	var is_mounted rune = 'u'
	if device.Is_mounted() {
		is_mounted = 'm'
	}

	var name string
	if label := device.Label; label != "" {
		name = fmt.Sprintf("%s (%s)", label, device.Path)
	} else {
		name = fmt.Sprintf("%s", device.Path)
	}

	return fmt.Sprintf("%s[%c] %s [%s]", device.Kind.As_string(), is_mounted, name, device.Size)
}

func GetDevices() ([]Device, error) {
	blocks, err := getBlocks()
	if err != nil {
		return nil, err
	}
	mtp, err := getMTP()
	if err != nil {
		return nil, err
	}
	return append(blocks, mtp...), nil
}

func getBlocks() ([]Device, error) {
	cmd := exec.Command(
		"lsblk",
		"--json",
		"--tree",
		"--output", "PATH,SIZE,LABEL,MOUNTPOINTS,HOTPLUG",
	)
	output, err := cmd.Output()
	if err != nil {
		return nil, err
	}

	var data map[string][]BlockDevice
	if err := json.Unmarshal(output, &data); err != nil {
		return nil, err
	}
	devices := []Device{}
	for _, blockdevice := range data["blockdevices"] {
		for _, device := range blockdevice.Children {
			device.Kind = USB
			slog.Debug("Block device parsed", "device", device, "added", device.Hotplug)
			if device.Hotplug {
				devices = append(devices, device)
			}
		}
	}

	return devices, nil
}

// TODO: get list of all available MTP devices
func getMTP() ([]Device, error) {
	return []Device{}, nil
}

// Mount a given device. Returns the path it was mounted on.
func (device Device) Mount() (string, error) {
	if device.Is_mounted() {
		slog.Error("Device is already mounted", "device", device.Path)
		return "", errors.New("device is already mounted")
	}
	slog.Debug("Mounting", "device", device)
	cmd := exec.Command("udisksctl", "mount", "-b", device.Path)
	output, err := cmd.Output()
	if err != nil {
		slog.Error("An error occurred while mounting device", "error", err, "device", device)
		return "", err
	}
	r := regexp.MustCompile(fmt.Sprintf("Mounted %s at (.*)", device.Path))
	matches := r.FindStringSubmatch(string(output))
	if matches == nil || len(matches) != 2 {
		slog.Error("Could not obtain mount path", "output", output, "device", device)
		return "", errors.New("Could not obtain mount path")
	}
	path := matches[1]
	slog.Info("Mounted device", "target", device.Path, "destination", path)
	return path, nil
}

func (device Device) Unmount() error {
	if !device.Is_mounted() {
		slog.Error("Device is not mounted", "device", device.Path)
		return errors.New("device is not mounted")
	}
	slog.Debug("Unmounting", "device", device)
	cmd := exec.Command("udisksctl", "unmount", "-b", device.Path)
	output, err := cmd.Output()
	if err != nil {
		slog.Error("An error occurred while unmounting device", "error", err, "device", device)
		return err
	}
	r := regexp.MustCompile("Unmounted (.*)\\.")
	matches := r.FindStringSubmatch(string(output))
	slog.Debug("Unmount regex matches", "matches", matches)
	if matches == nil || len(matches) != 2 {
		slog.Error("Could not obtain unmounted device path", "output", output, "device", device)
		return errors.New("Could not obtain unmounted device path")
	}
	path := matches[1]
	if path != device.Path {
		slog.Error("Mistmatch between device paths", "obtained", path, "expected", device.Path)
		return errors.New("Unmounted device path does not match what was expected")
	}
	slog.Info("Unmounted device", "target", device.Path)
	return nil
}
