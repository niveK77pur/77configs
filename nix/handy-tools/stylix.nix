{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.sx;
in {
  options.sx.enable = lib.mkEnableOption "sx";
  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    };
  };
}
