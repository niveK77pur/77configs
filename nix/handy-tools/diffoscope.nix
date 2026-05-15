{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.diffoscope;
in {
  options.diffoscope = {
    enable = lib.mkEnableOption "diffoscope";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.diffoscope];
  };
}
