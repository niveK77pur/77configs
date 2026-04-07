{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.sd;
in {
  options.sd = {
    enable = lib.mkEnableOption "sd";
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.singleton pkgs.sd;
  };
}
