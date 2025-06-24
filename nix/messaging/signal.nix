{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.signal;
in {
  options.signal = {
    enable = lib.mkEnableOption "signal";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.signal-desktop];
  };
}
