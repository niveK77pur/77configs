{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.noctalia;
in {
  imports = [inputs.noctalia.homeModules.default];

  options.noctalia = {
    enable = lib.mkEnableOption "noctalia";
  };

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      package = config.lib.nixGL.wrap inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
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
  };
}
