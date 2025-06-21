{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.chiaki;
in {
  options.chiaki = {
    enable = lib.mkEnableOption "chiaki";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.chiaki-ng];
  };
}
