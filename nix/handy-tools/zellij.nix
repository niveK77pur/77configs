{
  pkgs,
  lib,
  config,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "zellij";
  config = lib.mkIf config.zellij.enable {
    home.packages = [pkgs.zellij];
    xdg.configFile.zellij = {
      source = ../../config/zellij;
      recursive = true;
    };
  };
}
