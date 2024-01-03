package environment

import (
	"fmt"
	"io"
	"log/slog"
	dev "niveK77pur/mount/internal/device"
	"os"
	"os/exec"
	"strings"

	"github.com/gen2brain/beeep"
	"github.com/pterm/pterm"
)

const MOUNT_PROMPT = "Choose device to (un)mount"

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
func (env evironment) Choose(devices []dev.Device) (dev.Device, error) {
	switch env {
	case TTY, TERMINAL:
		return env.choose_terminal(devices), nil
	case X11:
		return env.choose_dmenu(devices)
	case WAYLAND:
		panic("TODO: implement wayland device chooser")
	default:
		panic("Unhandled environment for device chooser")
	}
}

func (env evironment) choose_terminal(devices []dev.Device) dev.Device {
	options := devices_to_strings(&devices)
	selection, err := pterm.DefaultInteractiveSelect.
		WithDefaultText(MOUNT_PROMPT).
		WithOptions(options).
		Show()
	if err != nil {
		slog.Error("Error while choosing device", "err", err.Error())
	}

	device := get_device_from_string_list(selection, devices, options)
	return device
}

func (env evironment) choose_dmenu(devices []dev.Device) (dev.Device, error) {
	slog.Info("Launching dmenu for selection")
	cmd := exec.Command("dmenu", "-i", "-l", "20", "-p", MOUNT_PROMPT)
	stdin, err := cmd.StdinPipe()
	if err != nil {
		return dev.Device{}, err
	}
	options := devices_to_strings(&devices)
	options_stdin := strings.Join(options, "\n")
	io.WriteString(stdin, options_stdin)
	stdin.Close()

	slog.Debug(
		"Options passed to stdin for dmenu",
		"options",
		options,
		"options_stdin",
		options_stdin,
	)

	output, err := cmd.Output()
	if err != nil {
		slog.Error("Error while choosing device", "err", err.Error())
		return dev.Device{}, err
	}
	// output contains a trailing \n
	var selection string = strings.Trim(string(output), "\n")

	slog.Debug("dmenu device choosing", "selection", selection)

	return get_device_from_string_list(selection, devices, options), nil
}

func devices_to_strings(devices *[]dev.Device) []string {
	options := make([]string, len(*devices))
	for i, device := range *devices {
		options[i] = device.As_string()
	}
	return options
}

func get_device_from_string_list(
	device_string string,
	devices []dev.Device,
	devices_string_list []string,
) dev.Device {
	var idx int = -1
	for i, option := range devices_string_list {
		if option == device_string {
			idx = i
			break
		}
	}

	if idx < 0 {
		// This case should not occur
		slog.Error(
			"Failed to find selected string in array",
			"device string",
			device_string,
			"device list",
			devices_string_list,
		)
		panic("Failed to find selected string in array")
	}
	slog.Debug(
		"Selected device",
		"device string",
		device_string,
		"index",
		idx,
		"device",
		devices[idx],
	)

	return devices[idx]
}
