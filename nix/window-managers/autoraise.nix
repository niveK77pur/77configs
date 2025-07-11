{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.autoraise;
in {
  options.autoraise = {
    enable = lib.mkEnableOption "autoraise";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.autoraise];
  };
}
