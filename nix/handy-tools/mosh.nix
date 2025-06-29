{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mosh;
in {
  options.mosh = {
    enable = lib.mkEnableOption "mosh";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.mosh];
  };
}
