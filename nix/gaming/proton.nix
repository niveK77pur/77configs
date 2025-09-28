{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.proton;
in {
  options.proton = {
    enable = lib.mkEnableOption "gaming.proton";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.protonplus
    ];
  };
}
