package device

type devicetype int

const (
	USB devicetype = iota
	MTP
)

type Device struct {
	name    string
	mounted bool
	kind    devicetype
}

// TODO: get list of all available devices
func GetDevices() []Device { return []Device{} }

// TODO: mount the device
func (device Device) Mount() int { return 0 }

// TODO: unmount the device
func (device Device) Unmount() int { return 0 }
