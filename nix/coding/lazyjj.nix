{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.lazyjj;
in {
  options.lazyjj = {
    enable = lib.mkEnableOption "lazyjj";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.lazyjj];
  };
}
