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
        feh
      ];

    xdg.configFile.lf = {
      source = ../../config/lf;
      recursive = true;
    };
  };
}
