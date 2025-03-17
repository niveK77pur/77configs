{
  config,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./fuzzel.nix
    ./dunst.nix
    ./swww.nix
    ./clipse.nix
    ./eww.nix
  ];

  options.window-managers.enableAll = lib.mkEnableOption "window-managers";

  config = lib.mkIf config.window-managers.enableAll {
    hyprland.enable = lib.mkDefault true;
    fuzzel.enable = lib.mkDefault true;
    dunst.enable = lib.mkDefault true;
    swww.enable = lib.mkDefault true;
    clipse.enable = lib.mkDefault true;
    eww.enable = lib.mkDefault true;
  };
}
