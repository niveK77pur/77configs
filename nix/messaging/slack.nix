{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.slack;
in {
  options.slack = {
    enable = lib.mkEnableOption "slack";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.slack];
  };
}
