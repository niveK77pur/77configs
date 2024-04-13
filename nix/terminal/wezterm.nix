{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = [pkgs.wezterm];
    xdg.configFile = setConfigsRecursive ../../config/wezterm;
  };
}
