{
  pkgs,
  setConfigsRecursive,
  ...
}: {
  config = {
    home.packages = with pkgs;
      [lf]
      ++ [
        pistol
        xdragon
        chafa
        file
        ffmpegthumbnailer
        lazygit
      ];

    xdg.configFile = setConfigsRecursive ../../config/lf;
  };
}
