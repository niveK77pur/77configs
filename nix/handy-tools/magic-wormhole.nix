{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.magic-wormhole;
in {
  options.magic-wormhole = {
    enable = lib.mkEnableOption "magic-wormhole";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.magic-wormhole-rs];
  };
}
