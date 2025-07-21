{
  lib,
  config,
  ...
}: let
  cfg = config.hypridle;
in {
  options.hypridle = {
    enable = lib.mkEnableOption "hypridle";
  };

  config = lib.mkIf cfg.enable (let
    min2seconds = minutes: builtins.ceil (minutes * 60);
  in {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = min2seconds 5;
            on-timout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = min2seconds 6;
            on-timout = "loginctl lock-session";
          }
          {
            timeout = min2seconds 60;
            on-timout = "systemctl suspend";
          }
        ];
      };
    };
  });
}
