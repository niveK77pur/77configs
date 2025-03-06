{
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./fuzzel.nix
    ./dunst.nix
  ];

  options.window-managers.enableAll = lib.mkEnableOption "window-managers";

  config = lib.mkIf config.window-managers.enableAll {
    hyprland.enable = lib.mkDefault true;
    fuzzel.enable = lib.mkDefault true;
    dunst.enable = lib.mkDefault true;
  };
}
