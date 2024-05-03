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
    font_size = lib.mkOption {
      type = lib.types.float;
      default = 12.0;
      description = "Font size for wezterm";
    };
  };

  config = {
    home.packages = with pkgs; [
      wezterm
      (nerdfonts.override {fonts = ["FiraCode" "VictorMono"];})
    ];
    xdg.configFile."wezterm/wezterm.lua".source = pkgs.stdenvNoCC.mkDerivation {
      pname = "wezterm.lua";
      version = "latest";
      src = ../../../config/wezterm;
      patches = [
        (pkgs.substituteAll {
          src = ./wezterm.patch;
          inherit (cfg) window_background_opacity font_size;
        })
      ];
      installPhase = "install -Dm311 wezterm.lua $out";
    };
  };
}
