{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.glab;
in {
  options.glab = {
    enable = lib.mkEnableOption "glab";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.glab];
  };
}
