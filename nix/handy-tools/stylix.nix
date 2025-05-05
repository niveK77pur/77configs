{
  pkgs,
  lib,
  config,
  stylix,
  ...
}: let
  cfg = config.sx;
in {
  imports = [stylix.homeManagerModules.stylix];
  disabledModules = [
    "${stylix}/modules/kde/hm.nix"
    "${stylix}/modules/xresources/hm.nix"
    "${stylix}/modules/sxiv/hm.nix"
    "${stylix}/modules/mpv/hm.nix"
    "${stylix}/modules/neovim/hm.nix"
  ];

  options.sx.enable = lib.mkEnableOption "sx";

  config = lib.mkIf cfg.enable {
    stylix = {
      cursor = {
        name = "Bibata-Modern-Amber";
        package = pkgs.bibata-cursors;
        size = 22;
      };

      enable = true;

      fonts = {
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };

        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCodeNerdFont";
        };

        sansSerif = {
          package = pkgs.ibm-plex;
          name = "IBMPlexSans";
        };

        serif = {
          package = pkgs.crimson;
          name = "Crimson";
        };

        sizes.terminal = 7;
      };

      # image = pkgs.fetchurl {
      #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      # };
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

      polarity = "dark";

      # TODO: Remove this override, which is necessary since commit [1] ("qt:
      # autoenable hm module only on NixOS (#942)"), once [2] ("qt: puts NixOS
      # systemd on non-NixOS distro path") is resolved.
      #
      # [1]: https://github.com/danth/stylix/commit/2c20aed3b39a87b8ab7c0d1fef44987f8a69b2d3
      # [2]: https://github.com/danth/stylix/issues/933
      targets.qt.enable = true;
    };
  };
}
