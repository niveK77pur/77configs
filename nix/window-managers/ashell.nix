{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ashell;
in {
  options.ashell = {
    enable = lib.mkEnableOption "ashell";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.ashell];
  };
}
