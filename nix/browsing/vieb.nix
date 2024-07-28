{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vieb.enable = lib.mkEnableOption "vieb" // {default = true;};

  config = lib.mkIf config.vieb.enable {
    home.packages = [pkgs.vieb];
    xdg.configFile.Vieb = {
      source = ../../config/Vieb;
      recursive = true;
    };
  };
}
