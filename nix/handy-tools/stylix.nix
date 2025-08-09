{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.sx;
in {
  imports = [inputs.stylix.homeModules.stylix];

  options.sx.enable = lib.mkEnableOption "sx";

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.vimPlugins.nightfox-nvim}/extra/duskfox/base16.yaml";
      fonts = {
        monospace = {
          package = pkgs.maple-mono.NF;
          name = "Maple Mono NF";
        };
        sansSerif = {
          package = pkgs.carlito;
          name = "Carlito";
        };
        serif = {
          # TODO: Find better font
          package = pkgs.carlito;
          name = "Carlito";
        };
      };
      targets = {
        neovim.enable = false;
        firefox.enable = false;
        floorp.profileNames = ["default"];
      };
    };
  };
}
