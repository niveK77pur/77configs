{
  lib,
  config,
  ...
}: let
  cfg = config.hyprland;
in {
  options.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty.enable = true; # required for the default Hyprland config
    wayland.windowManager.hyprland = {
      enable = true; # enable Hyprland
      # but do not install Hyprland
      package = null;
      portalPackage = null;
    };

    # Optional, hint Electron apps to use Wayland:
    # home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
