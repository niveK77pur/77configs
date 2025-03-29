{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hyprland;
  #  {{{
  envVars = {
    # Hint Electron apps to use Wayland:
    NIXOS_OZONE_WL = "1";
    # XCURSOR_SIZE = "24";
    # XDG_CURRENT_DESKTOP = "Hyprland";
    # XDG_SESSION_TYPE = "wayland";
    # XDG_SESSION_DESKTOP = "Hyprland";
    # GDK_BACKEND = "wayland,x11";
    # QT_QPA_PLATFORM = "wayland;xcb";
    # SDL_VIDEODRIVER = "wayland";
    # CLUTTER_BACKEND = "wayland";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
  }; #  }}}
  #  {{{
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
    ]; #  }}}
  #  {{{
  mkWindowRule = {
    # See: https://wiki.hyprland.org/Configuring/Window-Rules/
    rules,
    parameters,
  }:
    lib.lists.map (rule: "${rule}, ${parameters}") rules;
  #  }}}
in {
  options.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    #  {{{1
    terminal = lib.mkOption {
      default = "${config.wezterm.package}/bin/wezterm";
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
      home.packages = [pkgs.hyprshot pkgs.satty];

      programs.kitty.enable = true; # required for the default Hyprland config
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

              drop_shadow = true;
              shadow_range = 4;
              shadow_render_power = 3;
              # col.shadow = "rgba (1 a1a1aee)"; # ISSUE: Option does not exist anymore
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
            # # Example per-device config
            # # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
            # "device:epic-mouse-v1" = {
            #   sensitivity = -0.5;
            # };

            # Window Rules {{{1
            # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
            # TODO: Create and add window rules
            windowrulev2 = [
              "float, class:clipse"
              "size 622 652, class:clipse"
              "stayfocused, class:clipse"
            ];

            # Key Bindings {{{1
            # See https://wiki.hyprland.org/Configuring/Binds/ for more

            # See https://wiki.hyprland.org/Configuring/Keywords/ for more
            "$mainMod" = "SUPER";

            bind = [
              "$mainMod, RETURN, exec, ${cfg.terminal}"
              "$mainMod CTRL, RETURN, exec, [float] ${cfg.terminal}"
              "$mainMod SHIFT, Q, killactive,"
              "$mainMod, M, exit,"
              "$mainMod, SPACE, togglefloating,"
              "$mainMod, D, exec, exec `${cfg.launcher}`"
              # "$mainMod, P, pseudo, # dwindle"
              # "$mainMod, J, togglesplit, # dwindle"

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
            bindm = [
              # Move/resize windows with mainMod + LMB/RMB and dragging
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];
            #  }}}1
          }
          (lib.attrsets.optionalAttrs (cfg.monitor != null) {
            monitor =
              builtins.map (
                m:
                  lib.strings.concatStringsSep ", " [
                    m.name
                    m.resolution
                    m.position
                    (builtins.toString m.scale)
                  ]
              )
              cfg.monitor;
          })
        ];
        extraConfig = lib.strings.concatLines [
          (mkSubMap {
            name = "screenshot";
            trigger = "$mainMod,X";
            settings = {
              bind =
                [
                  "$mainMod, S, exec, hyprshot -m region --clipboard-only"
                  "$mainMod, S, submap, reset"

                  "$mainMod, W, exec, hyprshot -m window"
                  "$mainMod, W, submap, reset"

                  "$mainMod, F, exec, hyprshot -m output"
                  "$mainMod, F, submap, reset"

                  "$mainMod, R, exec, hyprshot -m region --raw | ${pkgs.imagemagick}/bin/convert - -resize 400x - | wl-copy"
                  "$mainMod, R, submap, reset"
                ]
                ++ (
                  if config.home.withNixGL.enable
                  then [
                    "$mainMod, E, exec, [float] hyprshot -m region --raw | ${config.home.withNixGL.command} satty --filename -"
                    "$mainMod, E, submap, reset"
                  ]
                  else [
                    "$mainMod, E, exec, notify-send screenshot Enable nixGL for `satty` to work"
                    "$mainMod, E, submap, reset"
                  ]
                );
            };
          })
        ];
      };

      home.sessionVariables = envVars;
    };
}
# vim: foldmethod=marker

