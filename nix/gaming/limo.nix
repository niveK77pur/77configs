{
  lib,
  config,
  ...
}: let
  cfg = config.limo;
in {
  options.limo = {
    enable = lib.mkEnableOption "limo";
  };

  config = lib.mkIf cfg.enable {
    multiverse.pins.limo = "1.2"; # NOTE: Latest 1.2.2 build is broken
    reshade-steam-proton.enable = true;
  };
}
