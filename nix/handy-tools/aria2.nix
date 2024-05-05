{pkgs, ...}: {
  config = {
    home.packages = [pkgs.aria2];
    xdg.configFile.aria2 = {
      source = ../../config/aria2;
      recursive = true;
    };
  };
}
