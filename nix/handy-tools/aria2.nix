{
  pkgs,
  lib,
  config,
  ...
}: {
  options.aria2.enable = lib.mkEnableOption "aria2" // {default = true;};
  config = lib.mkIf config.aria2.enable {
    home.packages = [pkgs.aria2];
    xdg.configFile.aria2 = {
      source = ../../config/aria2;
      recursive = true;
    };
  };
}
