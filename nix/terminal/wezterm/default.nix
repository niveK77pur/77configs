{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.wezterm.overrides;
in {
  options.wezterm.enable = lib.mkEnableOption "wezterm";
  options.wezterm.package = lib.mkOption {
    type = lib.types.package;
    default =
      if config.home.withNixGL.enable
      then
        pkgs.writeShellScriptBin "wezterm" ''
          ${config.home.withNixGL.command} ${pkgs.wezterm}/bin/wezterm "$@"
        ''
      else pkgs.wezterm;
    description = "The wezterm package to be used";
  };
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

  config = lib.mkIf config.wezterm.enable {
    home.packages = [
      config.wezterm.package
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.victor-mono
    ];
    xdg.configFile."wezterm/wezterm.lua".source = pkgs.stdenvNoCC.mkDerivation {
      pname = "wezterm.lua";
      version = "latest";
      src = ../../../config/wezterm;
      patches = [
        (pkgs.replaceVars ./wezterm.patch {
          inherit (cfg) window_background_opacity font_size;
        })
      ];
      installPhase = "install -Dm311 wezterm.lua $out";
    };
  };
}
