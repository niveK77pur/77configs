package main

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount-go/internal/device"
	"niveK77pur/mount-go/internal/environment"

	"github.com/pterm/pterm"
)

var env = environment.TERMINAL

func main() {
	logger := slog.New(pterm.NewSlogHandler(&pterm.DefaultLogger))
	// pterm.DefaultLogger.Level = pterm.LogLevelDebug
	slog.SetDefault(logger)

	devices, err := dev.GetDevices()
	if err != nil {
		slog.Error(err.Error())
		return
	}
	device, err := env.Choose(devices)
	if err != nil {
		slog.Error(err.Error())
		return
	}
	if device.Is_mounted() {
		if err := device.Unmount(); err != nil {
			env.Notify(
				fmt.Sprintf("Error occured while unmounting %s:\n%s", device.Path, err.Error()),
			)
		} else {
			env.Notify(fmt.Sprintf("Unmounted %s", device.Path))
		}
	} else {
		path, err := device.Mount()
		if err != nil {
			env.Notify(fmt.Sprintf("Error occured while mounting %s:\n%s", device.Path, err.Error()))
		} else {
			env.Notify(fmt.Sprintf("Mounted %s at %s", device.Path, path))
		}
	}
}
