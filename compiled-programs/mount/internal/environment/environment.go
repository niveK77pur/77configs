package environment

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount/internal/device"
	"os"

	"github.com/gen2brain/beeep"
	"github.com/pterm/pterm"
)

type evironment int

const (
	TTY evironment = iota
	TERMINAL
	X11
	WAYLAND
)

func (env evironment) Notify(message string) {
	switch env {
	case TTY, TERMINAL:
		fmt.Println(message)
	case X11:
		exec_name, err := os.Executable()
		if err != nil {
			slog.Error("Failed to get executable name", "err", err.Error())
		}
		if err := beeep.Notify(exec_name, message, ""); err != nil {
			slog.Error("Failed to show notification", "err", err.Error())
		}
	case WAYLAND:
		slog.Error("TODO: implement wayland notifications")
	default:
		slog.Error("Unhandled environment", "env", env)
	}
}

// TODO: present user with list to pick from
func (env evironment) Choose(devices []dev.Device) dev.Device {
	switch env {
	case TTY, TERMINAL:
		return env.choose_terminal(devices)
	case X11:
		panic("TODO: implement x11 device chooser")
	case WAYLAND:
		panic("TODO: implement wayland device chooser")
	default:
		panic("Unhandled environment for device chooser")
	}
}

func (env evironment) choose_terminal(devices []dev.Device) dev.Device {
	options := make([]string, len(devices))
	for i, device := range devices {
		options[i] = device.As_string()
	}

	selection, err := pterm.DefaultInteractiveSelect.
		WithDefaultText("Choose a device").
		WithOptions(options).
		Show()
	if err != nil {
		slog.Error("Error while choosing device", "err", err.Error())
	}

	var idx int = -1
	for i, option := range options {
		if option == selection {
			idx = i
			break
		}
	}
	if idx < 0 {
		// This case should not occur
		slog.Error(
			"Failed to find selected string in array",
			"selection",
			selection,
			"options",
			options,
		)
		panic("Failed to find selected string in array")
	}

	slog.Debug("Selected device", "device string", selection, "index", idx, "device", devices[idx])

	return devices[idx]
}
