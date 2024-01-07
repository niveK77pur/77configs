package main

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount-go/internal/device"
	"niveK77pur/mount-go/internal/environment"
	"os"

	"github.com/pterm/pterm"
	"golang.org/x/term"
)

func main() {
	logger := slog.New(pterm.NewSlogHandler(&pterm.DefaultLogger))
	pterm.DefaultLogger.Level = getLogLevel()
	slog.SetDefault(logger)

	env := getEnvironment()

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

func getLogLevel() pterm.LogLevel {
	switch os.Getenv("LOG_LEVEL") {
	case "DISABLED":
		// LogLevelDisabled does never print.
		return pterm.LogLevelDisabled
	case "TRACE":
		// LogLevelTrace is the log level for traces.
		return pterm.LogLevelTrace
	case "DEBUG":
		// LogLevelDebug is the log level for debug.
		return pterm.LogLevelDebug
	case "INFO":
		// LogLevelInfo is the log level for info.
		return pterm.LogLevelInfo
	case "WARN":
		// LogLevelWarn is the log level for warnings.
		return pterm.LogLevelWarn
	case "ERROR":
		// LogLevelError is the log level for errors.
		return pterm.LogLevelError
	case "FATAL":
		// LogLevelFatal is the log level for fatal errors.
		return pterm.LogLevelFatal
	case "PRINT":
		// LogLevelPrint is the log level for printing.
		return pterm.LogLevelPrint
	default:
		return pterm.LogLevelError
	}
}

func getEnvironment() environment.Environment {
	if term.IsTerminal(int(os.Stdout.Fd())) {
		slog.Info("Found environment: TERMINAL")
		return environment.TERMINAL
	} else if os.Getenv("WAYLAND_DISPLAY") != "" {
		slog.Info("Found environment: WAYLAND")
		return environment.WAYLAND
	} else if os.Getenv("DISPLAY") != "" {
		slog.Info("Found environment: X11")
		return environment.X11
	} else {
		slog.Warn("Could not determine environment. Using TTY.")
		return environment.TTY
	}
}
