{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      wezterm
      (nerdfonts.override {fonts = ["FiraCode" "VictorMono"];})
    ];
    xdg.configFile = setConfigsRecursive ../../config/wezterm;
  };
}
