{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gamescope.enable = lib.mkEnableOption "gamescope" // {default = true;};
  config = lib.mkIf config.gamescope.enable {
    home.packages = [pkgs.gamescope];
  };
}
