{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.window-managers;
in {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );
  options.window-managers = {
    enableAll = lib.mkEnableOption "window-managers";
    isServerConfiguration = lib.mkEnableOption "window-managers server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf (cfg.enableAll && (!cfg.isServerConfiguration)) {
    autoraise.enable = lib.mkDefault pkgs.stdenv.isDarwin;
    clipse.enable = lib.mkDefault true;
    dunst.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    awww.enable = lib.mkDefault true;
  };
}
