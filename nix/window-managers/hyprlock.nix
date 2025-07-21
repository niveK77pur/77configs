{
  lib,
  config,
  ...
}: let
  cfg = config.hyprlock;
in {
  options.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        ignore_empty_input = true;
        "fingerprint:enabled" = true;
        background = {
          path = "screenshot";
          blur_passes = 4;
          vibrancy = 1.5;
        };
        input-field = {
          size = "30%, 5%";
          hide_input = true;

          fade_on_empty = false;

          halign = "center";
          valign = "center";
        };
        label = {
          text = lib.concatStringsSep "  <tt>  ◆  </tt>  " [
            "$USER"
            "$LAYOUT"
            "Attempt: $ATTEMPTS"
            "$TIME"
          ];
          position = "0%, -5%";
          valing = "top";
        };
      };
    };
  };
}
