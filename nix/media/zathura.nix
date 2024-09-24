{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zathura.enable = lib.mkEnableOption "zathura";
  config = lib.mkIf config.zathura.enable {
    home.packages = [pkgs.zathura];
    xdg.configFile.zathura = {
      source = ../../config/zathura;
      recursive = true;
    };
  };
}
