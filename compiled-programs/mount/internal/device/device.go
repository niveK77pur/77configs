package device

import (
	"encoding/json"
	"fmt"
	"os/exec"
)

type devicetype int

const (
	USB devicetype = iota
	MTP
)

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
	return fmt.Sprintf(
		"%v[%v] %s [%s] (%s)",
		device.Kind,
		len(device.Mountpoints) > 0,
		device.Label,
		device.Size,
		device.Path,
	)
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
