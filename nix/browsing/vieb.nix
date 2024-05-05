{pkgs, ...}: {
  config = {
    home.packages = [pkgs.vieb];
    xdg.configFile.Vieb = {
      source = ../../config/Vieb;
      recursive = true;
    };
  };
}
