{
  pkgs,
  lib,
  config,
  wrapNixGL,
  ...
}: let
  cfg = config.ghostty;
in {
  options.ghostty = {
    enable = lib.mkEnableOption "ghostty";
    package = lib.mkOption {
      type = lib.types.package;
      default = wrapNixGL {
        binName = "ghostty";
        inherit config;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.xdg-desktop-portal-gtk];
    programs.ghostty = {
      inherit (cfg) package;
      enable = true;
      installBatSyntax = false; # stuck on a previous generation
      settings = {
        theme = "duskfox";
        gtk-single-instance = true;
        keybind = [
          # Use hjkl to navigate splits
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:down"
          "ctrl+shift+k=goto_split:up"
          "ctrl+shift+l=goto_split:right"
          "ctrl+alt+up=unbind"
          "ctrl+alt+down=unbind"
          "ctrl+alt+right=unbind"
          "ctrl+alt+left=unbind"

          # Remove fullscreen toggle
          "ctrl+enter=unbind"
        ];
      };
      themes = {};
    };
  };
}
