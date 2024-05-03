{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.vieb];
    xdg.configFile = setConfigsRecursive ../../config/Vieb;
  };
}
