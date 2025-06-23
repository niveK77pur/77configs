{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.vieb;
in {
  options.vieb = {
    enable = lib.mkEnableOption "vieb";
    useWayland = lib.mkEnableOption "vieb-wayland";
    package = lib.mkOption {
      default =
        if cfg.useWayland
        then
          (pkgs.writeShellScriptBin "vieb" ''
            ${pkgs.vieb}/bin/vieb --enable-features=UseOzonePlatform --ozone-platform=wayland "$@"
          '')
        else pkgs.vieb;
      type = lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile.Vieb = {
      source = ../../config/Vieb;
      recursive = true;
    };
  };
}
