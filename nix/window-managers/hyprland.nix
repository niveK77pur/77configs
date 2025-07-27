{
  pkgs,
  lib,
  config,
  wrapNixGL,
  ...
}: let
  cfg = config.hyprland;
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
  mkSubMap = {
    name,
    settings,
    trigger,
    trigger-resets ? false,
  }:
    lib.strings.concatLines [
      "bind=${trigger}, submap, ${name}"
      "submap=${name}"

      (lib.hm.generators.toHyprconf {
        attrs = settings;
      })

      (lib.strings.optionalString trigger-resets "bind=${trigger}, submap, reset")
      "bind = , escape, submap, reset"
      "submap = reset"
    ];
  #  {{{1
  mkBind = {
    MODS ? "$mainMod",
    extraMods ? [],
    key,
    dispatcher ? "exec",
    params ? [],
    args ? [],
    submap-reset ? null,
  }: let
    # use lists as default values to completely exclude attribute from bind definition
    mods = lib.concatStringsSep " " (lib.lists.flatten [MODS extraMods]);
    bind = lib.concatStringsSep ", " (lib.lists.flatten [mods key dispatcher params args]);
  in
    if submap-reset == null
    then bind
    else [bind] ++ (lib.lists.optional submap-reset (lib.concatStringsSep ", " [mods key "submap" "reset"]));
  #  {{{1
  mkWindowRule = {
    # See: https://wiki.hyprland.org/Configuring/Window-Rules/
    rules,
    parameters,
  }:
    lib.lists.map (rule: "${rule}, ${parameters}") rules;
  #  {{{1
  mergeBindings = bindings:
  # we only expect to be providing the 'bin' familiy of settings here
    builtins.zipAttrsWith (_: values: lib.concatLists values) bindings;
  #  }}}1
in {
  options.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    #  {{{1
    terminal = lib.mkOption {
      default = "${config.ghostty.package}/bin/ghostty";
      type = lib.types.str;
      description = "Command to be executed for opening a terminal";
    };
    #  {{{1
    launcher = lib.mkOption {
      default = "${config.programs.fuzzel.package}/bin/fuzzel";
      type = lib.types.str;
      description = "Command to use for the app launcher";
    };
    #  {{{1
    monitor = lib.mkOption {
      default = null;
      type = lib.types.nullOr (lib.types.listOf (lib.types.submodule {
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
      }));
      description = "Options for monitors; see `hyprctl monitors all`";
    };
    #  }}}1
  };

  config =
    lib.mkIf cfg.enable
    {
      fuzzel.enable = true;
      dunst.enable = true;
      swww.enable = true;
      clipse.enable = true;
      ashell.enable = true;
      flameshot.enable = false;
      pass.enable = true;
      ghostty = {
        enable = true;
        settings_override = {
          font-size = 10;
        };
      };
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
        (wrapNixGL {
          binName = "satty";
          inherit config;
        })
        # needed by passmenu
        (pkgs.writeShellScriptBin "dmenu-wl" ''
          ${cfg.launcher} --dmenu "$@"
        '')
        pkgs.xdg-desktop-portal-hyprland
      ];

      services.hyprpolkitagent.enable = true;

      wayland.windowManager.hyprland = {
        enable = true; # enable Hyprland
        # but do not install Hyprland
        package = null;
        portalPackage = null;

        settings = lib.attrsets.mergeAttrsList [
          {
            # See https://wiki.hyprland.org/Configuring/Monitors/
            # monitor = ",preferred,auto,auto"; # TODO: keep this?

            exec-once = [
              "${config.services.dunst.package}/bin/dunst"
              "ashell"
              "swww-daemon"
              "gammastep"
            ];

            #  {{{1
            env =
              lib.attrsets.mapAttrsToList (
                name: value: "${name},${value}"
              )
              envVars;

            # Settings {{{1
            #  {{{2
            input = {
              # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
              kb_layout = "ch";
              kb_variant = "fr";

              follow_mouse = "1";

              touchpad = {
                natural_scroll = true;
                scroll_factor = "0.6";
                tap-to-click = false;
              };

              sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
              # accel_profile = adaptive
            };

            #  {{{3
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
                passes = 1;
                xray = true; # floating windows see through ignore tiled windows
              };
            };

            #  {{{2
            animations = {
              # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
              enabled = true;
              bezier = [
                "myBezier, 0.05, 0.9, 0.1, 1.05"
                "workspaceBZ, 0.7, 0, 0.3, 1"
              ];

              animation = [
                "windows, 1, 4, myBezier, popin"
                "border, 1, 3, default"
                # "borderangle, 1, 8, default
                "fade, 1, 7, default"
                "workspaces, 1, 3, workspaceBZ"
              ];
            };

            #  {{{2
            dwindle = {
              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              pseudotile = true;
              # you probably want this
              preserve_split = true;
              smart_split = true;
            };

            # {{{2
            master = {
              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              # new_is_master = true; # ISSUE: Option does not exist anymore
            };

            # {{{2
            gestures = {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = true;
              workspace_swipe_cancel_ratio = 0.3;
              workspace_swipe_forever = true;
            };

            # {{{2
            # group = {
            #   insert_after_current = false;
            #   # focus_removed_window = false;
            # };

            # {{{2
            misc = {
              enable_swallow = true;
              swallow_regex = "^org.wezfurlong.wezterm$";
              # cursor_zoom_factor = 1.0; # ISSUE: Option does not exist anymore
            };

            # {{{2
            binds = {
              workspace_back_and_forth = true;
            };

            # {{{2
            xwayland = {
              force_zero_scaling = true;
            };

            # {{{2
            # # Example per-device config
            # # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
            # "device:epic-mouse-v1" = {
            #   sensitivity = -0.5;
            # };

            # Window Rules {{{1
            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            windowrulev2 = lib.lists.concatLists [
              (mkWindowRule {
                parameters = "class:.*";
                rules = [
                  "center 1"
                ];
              })

              (mkWindowRule {
                parameters = "class:clipse";
                rules = [
                  "float"
                  "size 622 652"
                  "stayfocused"
                ];
              })

              (mkWindowRule {
                parameters = "class:thunderbird";
                rules = [
                  "monitor 0"
                  "workspace 8"
                  "noinitialfocus"
                ];
              })

              (mkWindowRule {
                parameters = "class:discord";
                rules = [
                  "monitor 0"
                  "workspace 9"
                  "noinitialfocus"
                ];
              })

              (mkWindowRule {
                parameters = "class:ferdium";
                rules = [
                  "monitor 0"
                  "workspace 9"
                  "noinitialfocus"
                ];
              })
            ];

            # Key Bindings {{{1
            # See https://wiki.hyprland.org/Configuring/Binds/ for more

            # See https://wiki.hyprland.org/Configuring/Keywords/ for more
            "$mainMod" = "SUPER";

            #  }}}1
          }
          (mergeBindings [
            {
              #  {{{1
              bind = [
                "$mainMod, RETURN, exec, ${cfg.terminal}"
                "$mainMod CTRL, RETURN, exec, [float] ${cfg.terminal}"
                "$mainMod SHIFT, Q, killactive,"
                "$mainMod, M, exec, wlogout --show-binds"
                (mkBind {
                  extraMods = ["CTRL"];
                  key = "SPACE";
                  dispatcher = "togglefloating";
                })
                (mkBind {
                  key = "SPACE";
                  dispatcher = "changegroupactive";
                })
                "$mainMod, D, exec, exec `${cfg.launcher}`"
                "$mainMod, P, exec, ${pkgs.pass}/bin/passmenu"

                # Move focus with mainMod + arrow keys {{{
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"
                "$mainMod, H, movefocus, l"
                "$mainMod, L, movefocus, r"
                "$mainMod, K, movefocus, u"
                "$mainMod, J, movefocus, d"
                #  }}}
                # Move window {{{
                "$mainMod SHIFT, H, movewindoworgroup, l"
                "$mainMod SHIFT, J, movewindoworgroup, d"
                "$mainMod SHIFT, K, movewindoworgroup, u"
                "$mainMod SHIFT, L, movewindoworgroup, r"
                #  }}}
                # Resize window {{{
                "$mainMod CTRL, H, resizeactive, -20% 0%"
                "$mainMod CTRL, J, resizeactive, 0% 20%"
                "$mainMod CTRL, K, resizeactive, 0% -20%"
                "$mainMod CTRL, L, resizeactive, 20% 0%"
                #  }}}

                # Switch workspaces with mainMod + [0-9] {{{
                "$mainMod, 1, workspace, 1"
                "$mainMod, 2, workspace, 2"
                "$mainMod, 3, workspace, 3"
                "$mainMod, 4, workspace, 4"
                "$mainMod, 5, workspace, 5"
                "$mainMod, 6, workspace, 6"
                "$mainMod, 7, workspace, 7"
                "$mainMod, 8, workspace, 8"
                "$mainMod, 9, workspace, 9"
                "$mainMod, 0, workspace, 10"
                #  }}}
                # Move active window to a workspace with mainMod + SHIFT + [0-9] {{{
                "$mainMod SHIFT, 1, movetoworkspace, 1"
                "$mainMod SHIFT, 2, movetoworkspace, 2"
                "$mainMod SHIFT, 3, movetoworkspace, 3"
                "$mainMod SHIFT, 4, movetoworkspace, 4"
                "$mainMod SHIFT, 5, movetoworkspace, 5"
                "$mainMod SHIFT, 6, movetoworkspace, 6"
                "$mainMod SHIFT, 7, movetoworkspace, 7"
                "$mainMod SHIFT, 8, movetoworkspace, 8"
                "$mainMod SHIFT, 9, movetoworkspace, 9"
                "$mainMod SHIFT, 0, movetoworkspace, 10"
                #  }}}
                # Focus urgend or last window
                "$mainMod, U, focusurgentorlast,"

                # Fullscreen windows
                "$mainMod, F, fullscreen,"
                "$mainMod SHIFT, F, fullscreenstate, 0 2"
                "$mainMod CTRL, F, fullscreenstate, 2 0"

                # Dunst notifications
                "$mainMod, F1, exec, ${pkgs.writeShellScript "dunst-toggle.sh" ''
                  dunstctl set-paused toggle
                  [ "$(dunstctl is-paused)" = "false" ] && notify-send --urgency=low "dunstctl" "Notifications are back on"
                ''}"
                "$mainMod, F2, exec, dunstctl history-pop"
                "$mainMod, F3, exec, dunstctl close"
                "$mainMod SHIFT, F3, exec, dunstctl close-all"

                # clipboard manager
                "$mainMod, V, exec, ${config.wezterm.package}/bin/wezterm start --class clipse -e clipse"
              ];
              #  {{{1
              bindm = [
                # Move/resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];
              #  }}}1
            }
            #  {{{1
            (lib.optionalAttrs config.avizo.enable {
              bindl = [
                ", XF86AudioMute, exec, ${config.avizo.package}/bin/volumectl toggle-mute"
              ];
              bindel = [
                ", XF86AudioRaiseVolume, exec, ${config.avizo.package}/bin/volumectl -u up"
                ", XF86AudioLowerVolume, exec, ${config.avizo.package}/bin/volumectl -u down"
                ", XF86MonBrightnessUp, exec, ${config.avizo.package}/bin/lightctl up"
                ", XF86MonBrightnessDown, exec, ${config.avizo.package}/bin/lightctl down"
              ];
            })
            #  {{{1
            (lib.optionalAttrs config.services.playerctld.enable {
              bindl = [
                ", XF86AudioPlay, exec, playerctl play-pause"
                ", XF86AudioPrev, exec, playerctl previous"
                ", XF86AudioNext, exec, playerctl next"
              ];
            })
            #  }}}1
          ])
          (lib.attrsets.optionalAttrs (cfg.monitor != null) {
            monitor =
              builtins.map (
                m:
                  lib.strings.concatStringsSep ", " ([
                      m.name
                      m.resolution
                      m.position
                      (builtins.toString m.scale)
                    ]
                    ++ (lib.mapAttrsToList (arg: val: "${arg}, ${toString val}") m.extraArgs))
              )
              cfg.monitor;
          })
        ];
        extraConfig = lib.strings.concatLines [
          (mkSubMap {
            name = "screenshot";
            trigger = "$mainMod,X";
            settings = {
              bind = lib.lists.concatLists [
                (mkBind {
                  key = "S";
                  params = "hyprshot -m region --clipboard-only";
                  submap-reset = true;
                })
                (mkBind {
                  key = "W";
                  params = "hyprshot -m window";
                  submap-reset = true;
                })
                (mkBind {
                  key = "F";
                  params = "hyprshot -m output";
                  submap-reset = true;
                })
                (mkBind {
                  key = "R";
                  params = "hyprshot -m region --raw | ${pkgs.imagemagick}/bin/convert - -resize 400x - | wl-copy";
                  submap-reset = true;
                })
                (mkBind {
                  key = "E";
                  params = "[float] hyprshot -m region --raw | satty --filename -";
                  submap-reset = true;
                })
              ];
            };
          })

          (mkSubMap {
            name = "system";
            trigger = "$mainMod,S";
            trigger-resets = true;
            settings = {
              bind = builtins.concatLists (builtins.genList (i: let
                  value = (i + 1) * 10;
                in [
                  # number row
                  (mkBind {
                    key = "code:${toString (i + 10)}";
                    params = "${config.avizo.package}/bin/lightctl set ${toString value}";
                  })
                  # character row right below
                  (mkBind {
                    key = "code:${toString (i + 24)}";
                    params = "${config.avizo.package}/bin/volumectl set ${toString value}";
                  })
                ])
                10);
            };
          })

          (mkSubMap {
            name = "layout";
            trigger = "$mainMod,W";
            trigger-resets = true;
            settings.bind = lib.lists.concatLists [
              # dwindle
              (mkBind {
                key = "D";
                dispatcher = "layoutmsg";
                params = "togglesplit";
                submap-reset = true;
              })
              (mkBind {
                key = "S";
                dispatcher = "layoutmsg";
                params = "swapsplit";
                submap-reset = true;
              })

              # grouped/tabbed windows
              (mkBind {
                key = "T";
                dispatcher = "togglegroup";
                submap-reset = true;
              })
              (mkBind {
                key = "L";
                dispatcher = "lockactivegroup";
                params = "toggle";
                submap-reset = true;
              })
            ];
          })
        ];
      };

      home.sessionVariables = envVars;
    };
}
# vim: foldmethod=marker

