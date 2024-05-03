{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.zellij];
    xdg.configFile = setConfigsRecursive ../../config/zellij;
  };
}
