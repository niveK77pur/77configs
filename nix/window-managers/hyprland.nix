{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hyprland;
  mainMod = "SUPER";
  resizeWindowAmount = 40;
  #  {{{1
  envVars = {
    # Hint Electron apps to use Wayland
    # https://wiki.hypr.land/Getting-Started/Master-Tutorial/#force-apps-to-use-wayland
    NIXOS_OZONE_WL = "1";

    # Toolkit Backend Variables
    # https://wiki.hypr.land/Configuring/Environment-variables/#toolkit-backend-variables
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # XDG Specifications
    # https://wiki.hypr.land/Configuring/Environment-variables/#xdg-specifications
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # Qt Variables
    # https://wiki.hypr.land/Configuring/Environment-variables/#qt-variables
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
    # QT_QPA_PLATFORMTHEME="qt5ct";
  };
  #  {{{1
  mkBind = {
    MODS ? mainMod,
    extraMods ? [],
    key,
    dispatcher ? "exec_cmd",
    params ? [],
    flags ? {},
  }: let
    serializedParams = lib.concatStringsSep ", " (map (p: lib.generators.toLua {} p) (lib.flatten params));
  in {
    _args =
      [
        (lib.concatStringsSep "+" (lib.flatten [MODS extraMods key]))
        (lib.generators.mkLuaInline "hl.dsp.${dispatcher}(${serializedParams})")
      ]
      ++ (lib.optional (flags != {}) flags);
  };
  #  }}}1
in {
  options.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    #  {{{1
    terminal = lib.mkOption {
      default = lib.getExe config.programs.wezterm.package;
      type = lib.types.str;
      description = "Command to be executed for opening a terminal";
    };
    #  {{{1
    launcher = lib.mkOption {
      default = lib.getExe config.programs.vicinae.package;
      type = lib.types.str;
      description = "Command to use for the app launcher";
    };
    #  {{{1
    monitor = lib.mkOption {
      default = [];
      type = lib.types.listOf (lib.types.submodule {
        options = {
          #  {{{2
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the monitor, see `hyprctl monitors all`";
            example = "DP-1";
          };
          #  {{{2
          resolution = lib.mkOption {
            default = "preferred";
            type = lib.types.str;
            description = "Resolution and refresh rate of the monitor";
            example = "1920x1080@144";
          };
          #  {{{2
          position = lib.mkOption {
            default = "auto";
            type = lib.types.str;
            description = "Position of the monitor";
            example = "1920x0";
          };
          #  {{{2
          scale = lib.mkOption {
            default = 1;
            type = lib.types.number;
            description = "Scale of the monitor";
            example = "1";
          };
          #  {{{2
          extraArgs = lib.mkOption {
            default = {};
            type = lib.types.attrs;
            description = "Scale of the monitor";
            example = ''{ mirror = "DP-1"; vrr = 1; }'';
          };
          #  }}}2
        };
      });
      description = "Options for monitors; see `hyprctl monitors all`";
    };
    #  }}}1
  };

  config =
    lib.mkIf cfg.enable
    {
      vicinae.enable = true;
      dunst.enable = true;
      awww.enable = true;
      clipse.enable = true;
      noctalia.enable = true;
      flameshot.enable = false;
      pass.enable = true;
      ghostty = {
        enable = true;
      };
      stylix.targets.ghostty.fonts.override.sizes.terminal = 10;
      programs.wezterm.settings.font_size = lib.mkForce 10;
      wlogout = {
        enable = true;
        override-layout = {
          Logout.action = "${pkgs.writeShellScript "hyprexitwithgrace" ''
            LOGFILE=/tmp/hypr/hyprexitwithgrace.log
            mkdir -p $(dirname "$LOGFILE")
            HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
            hyprctl --batch "$HYPRCMDS" >> "$LOGFILE" 2>&1
            hyprctl dispatch exit >> "$LOGFILE" 2>&1
          ''}";
        };
      };
      hyprlock.enable = true;
      hypridle.enable = true;
      gammastep.enable = true;
      avizo.enable = true;
      home.packages = [
        pkgs.hyprshot
        (config.lib.nixGL.wrap pkgs.satty)
        # needed by passmenu
        (pkgs.writeShellScriptBin "dmenu-wl" ''
          ${cfg.launcher} dmenu "$@"
        '')
        pkgs.xdg-desktop-portal-hyprland
      ];

      services.hyprpolkitagent.enable = true;

      wayland.windowManager.hyprland = {
        configType = "lua";
        enable = true; # enable Hyprland
        # but do not install Hyprland
        package = null;
        portalPackage = null;

        settings = lib.attrsets.mergeAttrsList [
          {
            #  {{{1
            env =
              lib.attrsets.mapAttrsToList (
                name: value: {_args = [name value];}
              )
              envVars;

            #  {{{1
            config = {
              #  {{{2
              input = {
                # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
                kb_layout = "ch";
                kb_variant = "fr";

                follow_mouse = 1;

                touchpad = {
                  natural_scroll = true;
                  scroll_factor = 0.6;
                  tap_to_click = false;
                };

                # sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                # accel_profile = adaptive
              };

              #  {{{2
              general = let
                gap_size = 10;
              in {
                # See https://wiki.hyprland.org/Configuring/Variables/ for more

                gaps_in = gap_size / 2;
                gaps_out = gap_size;
                border_size = 2;
                # col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg"; # ISSUE: Option does not exist anymore
                # col.inactive_border = "rgba(595959aa)"; # ISSUE: Option does not exist anymore

                layout = "dwindle";
                # layout = master

                resize_on_border = true;
              };

              #  {{{2
              decoration = {
                # See https://wiki.hyprland.org/Configuring/Variables/ for more

                rounding = 6;
                inactive_opacity = 0.9;

                blur = {
                  enabled = true;
                  size = 3;
                  passes = 2;
                  xray = true; # floating windows see through ignore tiled windows
                };
              };

              #  {{{2
              animations.enabled = true;

              #  {{{2
              dwindle = {
                # you probably want this
                preserve_split = true;
              };

              # {{{2
              gestures = {
                # See https://wiki.hyprland.org/Configuring/Variables/ for more
                workspace_swipe_cancel_ratio = 0.3;
                workspace_swipe_forever = true;
              };

              # {{{2
              misc = {
                enable_swallow = true;
                swallow_regex = "^org.wezfurlong.wezterm$|^com.mitchellh.ghostty$";
                swallow_exception_regex = ".*[yY]azi.*";
                # cursor_zoom_factor = 1.0; # ISSUE: Option does not exist anymore
              };

              # {{{2
              binds = {
                workspace_back_and_forth = true;
                allow_workspace_cycles = true;
              };

              # {{{2
              xwayland = {
                force_zero_scaling = true;
              };
            };

            # {{{1
            animation = [
              {
                leaf = "windows";
                enabled = true;
                speed = 4;
                bezier = "myBezier";
                style = "popin";
              }
              {
                leaf = "border";
                enabled = true;
                speed = 3;
                bezier = "default";
              }
              {
                leaf = "borderangle";
                enabled = true;
                speed = 8;
                bezier = "default";
              }
              {
                leaf = "fade";
                enabled = true;
                speed = 7;
                bezier = "default";
              }
              {
                leaf = "workspaces";
                enabled = true;
                speed = 3;
                bezier = "workspaceBZ";
              }
            ];

            # {{{1
            curve = [
              {
                _args = [
                  "myBezier"
                  {
                    type = "bezier";
                    points = [[0.05 0.9] [0.1 1.05]];
                  }
                ];
              }
              {
                _args = [
                  "workspaceBZ"
                  {
                    type = "bezier";
                    points = [[0.7 0] [0.3 1]];
                  }
                ];
              }
            ];

            # {{{1
            window_rule =
              [
                {
                  match.class = ".*";
                  center = true;
                }
                {
                  match.class = "clipse";
                  float = true;
                  size = [622 652];
                  stay_focused = true;
                }
                {
                  match.class = "thunderbird";
                  monitor = "0";
                  workspace = "8";
                  no_initial_focus = true;
                }
                # FIX: JetBrains problems: https://github.com/hyprwm/Hyprland/issues/2412
              ]
              # Messaging applications
              ++ (map (c: {
                match.class = c;
                monitor = "0";
                workspace = "9";
                no_initial_focus = true;
              }) ["discord" "ferdium" "Slack"]);

            #  {{{1
            gesture = {
              fingers = 3;
              direction = "horizontal";
              action = "workspace";
            };

            #  {{{1
            bind =
              [
                (mkBind {
                  key = "RETURN";
                  params = "${cfg.terminal}";
                })
                (mkBind {
                  extraMods = "CTRL";
                  key = "RETURN";
                  params = [cfg.terminal {float = true;}];
                })
                (mkBind {
                  extraMods = "SHIFT";
                  key = "Q";
                  dispatcher = "window.close";
                })
                (mkBind {
                  key = "M";
                  params = "wlogout --show-binds";
                })
                (mkBind {
                  extraMods = ["CTRL"];
                  key = "SPACE";
                  dispatcher = "window.float";
                })
                (mkBind {
                  key = "SPACE";
                  dispatcher = "group.next";
                })
                (mkBind {
                  extraMods = "SHIFT";
                  key = "SPACE";
                  dispatcher = "group.prev";
                })
                (mkBind {
                  key = "D";
                  params = "${cfg.launcher} toggle";
                })
                (mkBind {
                  key = "P";
                  params = "${pkgs.pass}/bin/passmenu";
                })

                # Move focus with mainMod + arrow keys {{{2
                (mkBind {
                  key = "H";
                  dispatcher = "focus";
                  params.direction = "left";
                })
                (mkBind {
                  key = "J";
                  dispatcher = "focus";
                  params.direction = "down";
                })
                (mkBind {
                  key = "K";
                  dispatcher = "focus";
                  params.direction = "up";
                })
                (mkBind {
                  key = "L";
                  dispatcher = "focus";
                  params.direction = "right";
                })

                # Move window {{{2
                (mkBind {
                  key = "H";
                  extraMods = "SHIFT";
                  dispatcher = "window.move";
                  params = {
                    direction = "left";
                    group_aware = true;
                  };
                })
                (mkBind {
                  key = "J";
                  extraMods = "SHIFT";
                  dispatcher = "window.move";
                  params = {
                    direction = "down";
                    group_aware = true;
                  };
                })
                (mkBind {
                  key = "K";
                  extraMods = "SHIFT";
                  dispatcher = "window.move";
                  params = {
                    direction = "up";
                    group_aware = true;
                  };
                })
                (mkBind {
                  key = "L";
                  extraMods = "SHIFT";
                  dispatcher = "window.move";
                  params = {
                    direction = "right";
                    group_aware = true;
                  };
                })

                # Resize window {{{2
                (mkBind {
                  key = "H";
                  extraMods = "CTRL";
                  dispatcher = "window.resize";
                  params = {
                    x = -resizeWindowAmount;
                    y = 0;
                    relative = true;
                  };
                  flags.repeating = true;
                })
                (mkBind {
                  key = "J";
                  extraMods = "CTRL";
                  dispatcher = "window.resize";
                  params = {
                    x = 0;
                    y = resizeWindowAmount;
                    relative = true;
                  };
                  flags.repeating = true;
                })
                (mkBind {
                  key = "K";
                  extraMods = "CTRL";
                  dispatcher = "window.resize";
                  params = {
                    x = 0;
                    y = -resizeWindowAmount;
                    relative = true;
                  };
                  flags.repeating = true;
                })
                (mkBind {
                  key = "L";
                  extraMods = "CTRL";
                  dispatcher = "window.resize";
                  params = {
                    x = resizeWindowAmount;
                    y = 0;
                    relative = true;
                  };
                  flags.repeating = true;
                })

                # Focus urgend or last window {{{2
                (mkBind {
                  key = "U";
                  dispatcher = "focus";
                  params.urgent_or_last = true;
                })

                # Fullscreen windows {{{2
                (mkBind {
                  key = "F";
                  dispatcher = "window.fullscreen";
                  # params = "fullscreen";
                })
                (mkBind {
                  extraMods = "SHIFT";
                  key = "F";
                  dispatcher = "window.fullscreen_state";
                  params = {
                    internal = 0;
                    client = 2;
                  };
                })
                (mkBind {
                  extraMods = "CTRL";
                  key = "F";
                  dispatcher = "window.fullscreen_state";
                  params = {
                    internal = 2;
                    client = 0;
                  };
                })

                # Dunst notifications {{{2
                (mkBind {
                  key = "F1";
                  params = pkgs.writeShellScript "dunst-toggle.sh" ''
                    dunstctl set-paused toggle
                    [ "$(dunstctl is-paused)" = "false" ] && notify-send --urgency=low "dunstctl" "Notifications are back on"
                  '';
                })
                (mkBind {
                  key = "F2";
                  params = "dunstctl history-pop";
                })
                (mkBind {
                  key = "F3";
                  params = "dunstctl close";
                })
                (mkBind {
                  extraMods = "SHIFT";
                  key = "F3";
                  params = "dunstctl close-all";
                })

                # clipboard manager {{{2
                (mkBind {
                  key = "V";
                  params = "${config.wezterm.package}/bin/wezterm start --class clipse -e clipse";
                })

                # Move/resize windows with mainMod + LMB/RMB and dragging {{{2
                (mkBind {
                  key = "mouse:272";
                  dispatcher = "window.drag";
                  flags = {mouse = true;};
                })
                (mkBind {
                  key = "mouse:273";
                  dispatcher = "window.resize";
                  flags = {mouse = true;};
                })

                # }}}2
              ]
              # {{{2
              ++ (lib.optionals config.avizo.enable [
                (mkBind {
                  MODS = [];
                  key = "XF86AudioMute";
                  params = "${config.avizo.package}/bin/volumectl toggle-mute";
                  flags = {locked = true;};
                })
                (mkBind {
                  MODS = [];
                  key = "XF86AudioRaiseVolume";
                  params = "${config.avizo.package}/bin/volumectl -u up";
                  flags = {
                    locked = true;
                    repeating = true;
                  };
                })
                (mkBind {
                  MODS = [];
                  key = "XF86AudioLowerVolume";
                  params = "${config.avizo.package}/bin/volumectl -u down";
                  flags = {
                    locked = true;
                    repeating = true;
                  };
                })
                (mkBind {
                  MODS = [];
                  key = "XF86MonBrightnessUp";
                  params = "${config.avizo.package}/bin/lightctl up";
                  flags = {
                    locked = true;
                    repeating = true;
                  };
                })
                (mkBind {
                  MODS = [];
                  key = "XF86MonBrightnessDown";
                  params = "${config.avizo.package}/bin/lightctl down";
                  flags = {
                    locked = true;
                    repeating = true;
                  };
                })
              ])
              # {{{2
              ++ (
                lib.optionals config.services.playerctld.enable [
                  (mkBind {
                    MODS = [];
                    key = "XF86AudioPlay";
                    params = "playerctl play-pause";
                    flags = {locked = true;};
                  })
                  (mkBind {
                    MODS = [];
                    key = "XF86AudioPrev";
                    params = "playerctl previous";
                    flags = {locked = true;};
                  })
                  (mkBind {
                    MODS = [];
                    key = "XF86AudioNext";
                    params = "playerctl next";
                    flags = {locked = true;};
                  })
                ]
              )
              # Workspace switching {{{2
              ++ (builtins.genList (i: let
                n = i + 1;
                k = toString (lib.mod n 10);
              in
                mkBind {
                  key = k;
                  dispatcher = "focus";
                  params = {workspace = n;};
                })
              9)
              ++ (builtins.genList (i: let
                n = i + 1;
                k = toString (lib.mod n 10);
              in
                mkBind {
                  key = k;
                  extraMods = "SHIFT";
                  dispatcher = "window.move";
                  params = {workspace = n;};
                })
              9);
            # }}}2

            # {{{1
            monitor =
              [
                {
                  output = "";
                  mode = "preferred";
                  position = "auto";
                  scale = "auto"; # or `1` ?
                }
              ]
              ++ (map (m: ({
                  output = m.name;
                  mode = m.resolution;
                  inherit (m) position scale;
                }
                // m.extraArgs))
              cfg.monitor);
            #  }}}1
          }
        ];
        extraLuaFiles = {
          "autostart" = {
            autoLoad = true;
            content = pkgs.writeText "hypr-autostart.lua" ''
              hl.on("hyprland.start", function()
                hl.exec_cmd("${config.services.dunst.package}/bin/dunst")
                hl.exec_cmd("${lib.getExe config.programs.noctalia-shell.package}")
                hl.exec_cmd("${lib.getExe config.services.gammastep.package}")
                hl.exec_cmd("${cfg.launcher} server")
              end)
            '';
          };
          "submap.screenshot" = {
            autoLoad = true;
            content = pkgs.replaceVars ../../config/hypr/extraLuaFiles/screenshot.lua {
              inherit mainMod;
              magick = lib.getExe pkgs.imagemagick;
              hyprshot-tesseract = pkgs.writers.writeFish "hyprshot-tesseract.fish" ''
                set text (hyprshot --freeze -m region --raw | ${lib.getExe pkgs.tesseract} - - | string collect)
                notify-send "hyprshot tesseract copy to clipboard" $text
                wl-copy $text
              '';
            };
          };
          "submap.system" = {
            autoLoad = true;
            content = pkgs.replaceVars ../../config/hypr/extraLuaFiles/system.lua {
              inherit mainMod;
              lightctl = "${config.avizo.package}/bin/lightctl";
              volumectl = "${config.avizo.package}/bin/volumectl";
            };
          };
          "submap.layout" = {
            autoLoad = true;
            content = pkgs.replaceVars ../../config/hypr/extraLuaFiles/layout.lua {inherit mainMod;};
          };
        };
      };

      home.sessionVariables = envVars;
    };
}
# vim: foldmethod=marker

