{
  lib,
  config,
  ...
}: let
  cfg = config.eww;
in {
  options.eww = {
    enable = lib.mkEnableOption "eww";
  };

  config = lib.mkIf cfg.enable {
    programs.eww = {
      enable = true;
      configDir = ../../config/eww;
    };
  };
}
