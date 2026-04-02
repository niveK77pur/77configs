{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.huly;
  huly = pkgs.writeShellApplication {
    name = "huly";
    text = ''
      chromium --app=https://huly.app
    '';
    runtimeInputs = [
      pkgs.chromium
    ];
  };
in {
  options.huly = {
    enable = lib.mkEnableOption "huly";
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.singleton huly;

    xdg.desktopEntries.huly = {
      name = "Huly";
      exec = lib.getExe huly;
      icon = builtins.fetchurl {
        url = "https://huly.io/favicon/favicon-512x512.png";
        sha256 = "19wvcpw767zzplr0ydivav6bvdzhj1llcl9nz6nz9wlf3927q7d9";
      };
      genericName = "Messaging Client";
      comment = "chromium app for huly.app";
      type = "Application";
      terminal = false;
    };
  };
}
