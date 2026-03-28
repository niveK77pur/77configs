{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.vicinae;
in {
  options.vicinae = {
    enable = lib.mkEnableOption "vicinae";
  };

  config = lib.mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.vicinae;
      # WARN: Launch from within Hyprland to inherit proper env vars
      # systemd.enable = true;
    };
  };
}
