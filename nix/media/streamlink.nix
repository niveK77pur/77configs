{
  lib,
  config,
  ...
}: let
  cfg = config.streamlink;
in {
  options.streamlink.enable = lib.mkEnableOption "streamlink";

  config = lib.mkIf cfg.enable {
    mpv.enable = true;
    programs.streamlink = {
      enable = true;
      settings = {
        player = "${config.programs.mpv.finalPackage}";
      };
    };
  };
}
