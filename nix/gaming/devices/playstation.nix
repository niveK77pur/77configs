{
  pkgs,
  config,
  lib,
  ...
}: {
  options.playstation.enable = lib.mkEnableOption "playstation";
  config = lib.mkIf config.playstation.enable {
    home.packages = with pkgs; [
      bluez # use PS controller via bluetooth
    ];
  };
}
