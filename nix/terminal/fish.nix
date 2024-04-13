{
  pkgs,
  lib,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.fish];
    xdg.configFile = setConfigsRecursive ../../config/fish;
  };
}
