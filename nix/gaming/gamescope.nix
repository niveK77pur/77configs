{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gamescope.enable = lib.mkEnableOption "gamescope";
  config = lib.mkIf config.gamescope.enable {
    home.packages = [pkgs.gamescope];
  };
}
