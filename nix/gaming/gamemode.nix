{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gamemode.enable = lib.mkEnableOption "gamemode" // {default = true;};
  config = lib.mkIf config.gamemode.enable {
    home.packages = with pkgs; [gamemode];
  };
}
