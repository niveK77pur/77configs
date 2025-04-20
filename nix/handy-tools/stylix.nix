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
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
}
