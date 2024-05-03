{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.wezterm.overrides;
in {
  options.wezterm.overrides = {
    window_background_opacity = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Background opacity for wezterm";
    };
  };

  config = {
    home.packages = with pkgs; [
      wezterm
      (nerdfonts.override {fonts = ["FiraCode" "VictorMono"];})
    ];
    xdg.configFile."wezterm/wezterm.lua".text =
      builtins.replaceStrings
      ["window_background_opacity = 1.0"]
      ["window_background_opacity = ${builtins.toString cfg.window_background_opacity}"]
      (builtins.readFile ../../config/wezterm/wezterm.lua);
  };
}
