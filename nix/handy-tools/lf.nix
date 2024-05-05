{pkgs, ...}: {
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

    xdg.configFile.lf = {
      source = ../../config/lf;
      recursive = true;
    };
  };
}
