{pkgs, ...}: {
  config = {
    home.packages = [pkgs.zathura];
    xdg.configFile.zathura = {
      source = ../../config/zathura;
      recursive = true;
    };
  };
}
