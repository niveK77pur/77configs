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
      type = lib.types.nullOr lib.types.package;
      default = wrapNixGL {
        binName = "ghostty";
        inherit config;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.lists.concatLists [
      [
        pkgs.nerd-fonts.fira-code
        pkgs.maple-mono.NF
      ]
      (lib.lists.optional pkgs.stdenv.isLinux pkgs.xdg-desktop-portal-gtk)
    ];
    programs.ghostty = {
      inherit (cfg) package;
      enable = true;
      installBatSyntax = false; # stuck on a previous generation
      settings = {
        # theme = "duskfox";
        font-family = "Maple Mono NF";
        # font-family-bold = "FiraCode NF";
        # font-family-italic = "Maple Mono NF";
        # font-family-bold-italic = "Maple Mono NF";
        unfocused-split-opacity = 0.5;
        gtk-single-instance = true;
        shell-integration-features = "sudo";
        keybind = let
          split_resize_amount = builtins.toString 100;
        in [
          # Use hjkl to navigate splits
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:down"
          "ctrl+shift+k=goto_split:up"
          "ctrl+shift+l=goto_split:right"

          # Remove fullscreen toggle
          "ctrl+enter=unbind"

          # Remove open config binding
          "ctrl+comma=unbind"

          # Resize splits wiht hjkl
          "super+ctrl+shift+h=resize_split:left,${split_resize_amount}"
          "super+ctrl+shift+j=resize_split:down,${split_resize_amount}"
          "super+ctrl+shift+k=resize_split:up,${split_resize_amount}"
          "super+ctrl+shift+l=resize_split:right,${split_resize_amount}"

          # remap to make default mappings work on swiss french layout
          "ctrl+shift+plus=increase_font_size:1"
          "ctrl+shift+semicolon=reload_config"
        ];
      };
      themes = {};
    };
  };
}
