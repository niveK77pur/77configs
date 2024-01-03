package main

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount/internal/device"
	env "niveK77pur/mount/internal/environment"
)

func main() {
	// logger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug}))
	// slog.SetDefault(logger)
	env.X11.Notify("Hello")
	devices, err := dev.GetDevices()
	if err != nil {
		slog.Error(err.Error())
	}
	for _, device := range devices {
		fmt.Println("device:", device)
	}
}
