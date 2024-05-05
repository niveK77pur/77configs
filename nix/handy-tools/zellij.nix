{pkgs, ...}: {
  config = {
    home.packages = [pkgs.zellij];
    xdg.configFile.zellij = {
      source = ../../config/zellij;
      recursive = true;
    };
  };
}
