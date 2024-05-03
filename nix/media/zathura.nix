{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.zathura];
    xdg.configFile = setConfigsRecursive ../../config/zathura;
  };
}
