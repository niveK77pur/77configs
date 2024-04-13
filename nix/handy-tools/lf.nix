{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.lf];
    xdg.configFile = setConfigsRecursive ../../config/lf;
  };
}
