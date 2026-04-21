{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.wezterm;
in {
  options.wezterm = {
    enable = lib.mkEnableOption "wezterm";
    package = lib.mkOption {
      type = lib.types.package;
      default = config.lib.nixGL.wrap pkgs.wezterm;
      description = "The wezterm package to be used";
    };
  };

  config = lib.mkIf config.wezterm.enable (lib.mkMerge [
    {
      programs.wezterm = {
        enable = true;
        inherit (cfg) package;
        settings = {
          # Interface {{{1
          enable_tab_bar = true;
          hide_tab_bar_if_only_one_tab = true;
          window_padding = let
            padding = 10;
          in {
            left = padding;
            right = padding;
            top = padding;
            bottom = padding;
          };
          # Behaviour {{{1
          warn_about_missing_glyphs = false;
          check_for_updates = false;
          scrollback_lines = 3500;

          # uses rust regex: https://docs.rs/regex/1.3.9/regex/#syntax
          quick_select_patterns = [
            ''\\b[[:alnum:][:punct:]]+\\b'' # "words"
          ];
          quick_select_alphabet = let
            # suggested alphabet for keyboard layout
            layouts = {
              qwerty = "asdfqwerzxcvjklmiuopghtybn";
              qwertz = "asdfqweryxcvjkluiopmghtzbn";
              azerty = "qsdfazerwxcvjklmuiopghtybn";
              dvorak = "aoeuqjkxpyhtnsgcrlmwvzfidb";
              colemak = "arstqwfpzxcvneioluymdhgjbk";
            };
          in
            layouts.qwertz;
          audible_bell = "Disabled";

          # {{{1
          keys = lib.flatten [
            {
              # Interferes with jjui
              key = "Enter";
              mods = "ALT";
              action = lib.generators.mkLuaInline "wezterm.action.DisableDefaultAssignment";
            }
            {
              # Match ghostty default
              key = "o";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.SplitHorizontal {domain="CurrentPaneDomain"}'';
            }
            {
              # Match ghostty default
              key = "e";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.SplitVertical {domain="CurrentPaneDomain"}'';
            }
            {
              key = "h";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.ActivatePaneDirection "Left"'';
            }
            {
              key = "j";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.ActivatePaneDirection "Down"'';
            }
            {
              key = "k";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.ActivatePaneDirection "Up"'';
            }
            {
              key = "l";
              mods = "CTRL|SHIFT";
              action = lib.generators.mkLuaInline ''wezterm.action.ActivatePaneDirection "Right"'';
            }
            (builtins.genList (i: {
                key = "${toString (i + 1)}";
                mods = "ALT";
                action = lib.generators.mkLuaInline ''wezterm.action.ActivateTab(${toString (
                    if i == 8
                    then -1
                    else i
                  )})'';
              })
              9)
          ];
          #  }}}1
        };
      };
    }
    {
      #  {{{
      stylix.targets.wezterm.enable = false;
      programs.wezterm = let
        inherit (config.stylix) fonts opacity;
        inherit
          (config.lib.stylix.colors)
          base00
          base01
          base03
          base05
          base06
          base07
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          ;
      in {
        colorSchemes.stylix = {
          ansi = [
            base00
            base08
            base0B
            base0A
            base0D
            base0E
            base0C
            base05
          ];
          brights = [
            base03
            base08
            base0B
            base0A
            base0D
            base0E
            base0C
            base07
          ];
          background = base00;
          cursor_bg = base05;
          cursor_fg = base00;
          compose_cursor = base06;
          foreground = base05;
          scrollbar_thumb = base01;
          selection_bg = base05;
          selection_fg = base00;
          split = base03;
          visual_bell = base09;
          tab_bar = {
            background = base01;
            inactive_tab_edge = base01;
            active_tab = {
              bg_color = base00;
              fg_color = base05;
            };
            inactive_tab = {
              bg_color = base03;
              fg_color = base05;
            };
            inactive_tab_hover = {
              bg_color = base05;
              fg_color = base00;
            };
            new_tab = {
              bg_color = base03;
              fg_color = base05;
            };
            new_tab_hover = {
              bg_color = base05;
              fg_color = base00;
            };
          };
        };
        settings = {
          color_scheme = "stylix";
          window_frame = {
            active_titlebar_bg = base03;
            active_titlebar_fg = base05;
            active_titlebar_border_bottom = base03;
            border_left_color = base01;
            border_right_color = base01;
            border_bottom_color = base01;
            border_top_color = base01;
            button_bg = base01;
            button_fg = base05;
            button_hover_bg = base05;
            button_hover_fg = base03;
            inactive_titlebar_bg = base01;
            inactive_titlebar_fg = base05;
            inactive_titlebar_border_bottom = base03;
          };
          colors = {
            tab_bar = {
              background = base01;
              inactive_tab_edge = base01;
              active_tab = {
                bg_color = base00;
                fg_color = base05;
              };
              inactive_tab = {
                bg_color = base03;
                fg_color = base05;
              };
              inactive_tab_hover = {
                bg_color = base05;
                fg_color = base00;
              };
              new_tab = {
                bg_color = base03;
                fg_color = base05;
              };
              new_tab_hover = {
                bg_color = base05;
                fg_color = base00;
              };
            };
          };
          command_palette_bg_color = base01;
          command_palette_fg_color = base05;

          font = lib.generators.mkLuaInline ''wezterm.font_with_fallback { "${fonts.monospace.name}", "${fonts.emoji.name}" }'';
          font_size = fonts.sizes.terminal;

          command_palette_font_size = fonts.sizes.popups;
          window_background_opacity = opacity.terminal;
        };
      };
      #  }}}
    }
  ]);
}
# vim: fdm=marker

