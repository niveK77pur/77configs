package environment

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount/internal/device"
)

type evironment int

const (
	TTY evironment = iota
	TERMINAL
	X11
	WAYLAND
)

// TODO: present a notification to the user
func (env evironment) Notify(message string) {
	switch env {
	case TTY:
		fmt.Println(message)
	case TERMINAL:
		fmt.Println(message)
	case X11:
		fmt.Println("TODO", "use notify-send", message)
	case WAYLAND:
		fmt.Println("TODO", "use notify-send", "test")
	default:
		slog.Error("Unhandled environment", "env", env)
	}
}

// TODO: present user with list to pick from
func (env evironment) choose(devices []dev.Device) int { return 0 }
