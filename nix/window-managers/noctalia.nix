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
    programs.noctalia = {
      enable = true;
      package = config.lib.nixGL.wrap inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        bar.main = {
          position = "right";
          margin_ends = 0;
          margin_edge = 0;
        };
        shell = {
          screen_corners = {
            enabled = true;
            size = 20;
          };
        };
        wallpaper.enabled = false;
        # widget = {
        #   workspaces.labels_only_when_occupied = false;
        # };
      };
    };
  };
}
