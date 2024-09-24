{
  pkgs,
  config,
  lib,
  ...
}: {
  options.fonts.enableAll = lib.mkEnableOption "fonts";
  config = lib.mkIf config.fonts.enableAll {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      gyre-fonts
    ];
  };
}
