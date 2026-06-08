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
          # {{{1
          mouse_bindings = let
            scroll = 3;
          in [
            {
              event.Down = {
                streak = 1;
                button.WheelUp = 1;
              };
              mods = "NONE";
              action = lib.generators.mkLuaInline "wezterm.action.ScrollByLine(${toString (- scroll)})";
              alt_screen = false;
            }
            {
              event.Down = {
                streak = 1;
                button.WheelDown = 1;
              };
              mods = "NONE";
              action = lib.generators.mkLuaInline "wezterm.action.ScrollByLine(${toString scroll})";
              alt_screen = false;
            }
          ];
          #  }}}1
        };
      };
    }
  ]);
}
# vim: fdm=marker

