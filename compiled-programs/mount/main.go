package main

import (
	"log/slog"
	dev "niveK77pur/mount/internal/device"
	env "niveK77pur/mount/internal/environment"

	"github.com/pterm/pterm"
)

func main() {
	logger := slog.New(pterm.NewSlogHandler(&pterm.DefaultLogger))
	// pterm.DefaultLogger.Level = pterm.LogLevelDebug
	slog.SetDefault(logger)

	env.X11.Notify("Hello")
	devices, err := dev.GetDevices()
	if err != nil {
		slog.Error(err.Error())
	}
	env.TERMINAL.Choose(devices)
}
