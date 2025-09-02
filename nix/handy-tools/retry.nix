{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.retry;
in {
  options.retry = {
    enable = lib.mkEnableOption "retry";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.retry];
  };
}
