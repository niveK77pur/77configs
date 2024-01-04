package device

import (
	"encoding/json"
	"fmt"
	"log/slog"
	"os/exec"
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
	Kind        devicetype
}

func (device Device) As_string() string {
	var is_mounted rune = 'm'
	if len(device.Mountpoints) == 1 && device.Mountpoints[0] == "" {
		// https://stackoverflow.com/q/35866221
		// An empty []string is not actually empty.
		// There will be a single empty string ("") inside.
		is_mounted = 'u'
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
		"--output", "PATH,SIZE,LABEL,MOUNTPOINTS",
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
			devices = append(devices, device)
			slog.Debug("Block device parsed", "device", device)
		}
	}

	return devices, nil
}

// TODO: get list of all available MTP devices
func getMTP() ([]Device, error) {
	return []Device{}, nil
}

// TODO: mount the device
func (device Device) Mount() int { return 0 }

// TODO: unmount the device
func (device Device) Unmount() int { return 0 }
