{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.noctalia;
in {
  options.noctalia = {
    enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.noctalia-shell;
      # 4.7.x is legacy v4 and has no `config validate` subcommand.
      checkConfig = false;
    };

    xdg.configFile."noctalia/settings.json".source = (pkgs.formats.json {}).generate "noctalia-settings.json" {
      bar = {
        position = "right";
        outerCorners = false;
        widgets = {
          center = [
            {
              id = "Workspace";
              showLabelsOnlyWhenOccupied = false;
            }
          ];
        };
      };
      wallpaper.enabled = false;
    };
  };
}
