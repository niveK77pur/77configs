{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.aria2];
    xdg.configFile = setConfigsRecursive ../../config/aria2;
  };
}
