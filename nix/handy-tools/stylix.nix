{
  pkgs,
  lib,
  config,
  stylix,
  ...
}: let
  cfg = config.sx;
in {
  imports = [stylix.homeModules.stylix];

  options.sx.enable = lib.mkEnableOption "sx";

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.vimPlugins.nightfox-nvim}/extra/duskfox/base16.yaml";
      targets = {
        neovim.enable = false;
      };
    };
  };
}
