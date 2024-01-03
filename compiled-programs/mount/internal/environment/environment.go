package environment

import (
	"fmt"
	"log/slog"
	dev "niveK77pur/mount/internal/device"
	"os"

	"github.com/gen2brain/beeep"
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
func (env evironment) choose(devices []dev.Device) int { return 0 }
