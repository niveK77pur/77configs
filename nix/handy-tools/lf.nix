{
  pkgs,
  lib,
  config,
  ...
}: {
  options.lf.enable = lib.mkEnableOption "lf" // {default = true;};
  config = lib.mkIf config.lf.enable {
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
        imagemagick
        ghostscript
      ];

    xdg.configFile.lf = {
      source = ../../config/lf;
      recursive = true;
    };
  };
}
