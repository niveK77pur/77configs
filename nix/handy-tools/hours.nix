{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.hours;
in {
  options.hours = {
    enable = lib.mkEnableOption "hours";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.hours];
  };
}
