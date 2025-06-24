{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.wlogout;
in {
  options.wlogout = {
    enable = lib.mkEnableOption "wlogout";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.wlogout];
  };
}
# vim: fdm=marker

