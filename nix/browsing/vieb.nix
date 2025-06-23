{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.vieb;
in {
  options.vieb.enable = lib.mkEnableOption "vieb";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.vieb];
    xdg.configFile.Vieb = {
      source = ../../config/Vieb;
      recursive = true;
    };
  };
}
