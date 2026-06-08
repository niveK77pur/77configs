{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.fonts;
in {
  options.fonts = {
    enableAll = lib.mkEnableOption "fonts";
    isServerConfiguration = lib.mkEnableOption "fonts server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf (cfg.enableAll && (!cfg.isServerConfiguration)) {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      gyre-fonts
    ];
  };
}
