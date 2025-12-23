{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.duf;
in {
  options.duf = {
    enable = lib.mkEnableOption "duf";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.duf];
  };
}
