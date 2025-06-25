{
  lib,
  config,
  ...
}: let
  cfg = config.gammastep;
in {
  options.gammastep = {
    enable = lib.mkEnableOption "gammastep";
  };

  config = lib.mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      tray = true;
      provider = "geoclue2";
      temperature = {
        day = 6500;
        night = 4300;
      };
      settings = {
        general = {
          gamma-night = 0.9;
        };
      };
    };
  };
}
