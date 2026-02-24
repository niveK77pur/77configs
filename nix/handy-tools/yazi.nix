{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.yazi;
in {
  options.yazi = {
    enable = lib.mkEnableOption "yazi";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      yazi = {
        enable = true;
        shellWrapperName = "y";
        extraPackages = [
          pkgs.exiftool
          pkgs.mediainfo
        ];
      };
    };
  };
}
