package main

import (
	env "niveK77pur/mount/internal/environment"
)

func main() {
	// logger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: slog.LevelDebug}))
	// slog.SetDefault(logger)
	env.X11.Notify("Hello")
}
