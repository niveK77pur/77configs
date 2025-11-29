{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );

  options.window-managers.enableAll = lib.mkEnableOption "window-managers";

  config = lib.mkIf config.window-managers.enableAll {
    hyprland.enable = lib.mkDefault true;
    dunst.enable = lib.mkDefault true;
    swww.enable = lib.mkDefault true;
    clipse.enable = lib.mkDefault true;
    autoraise.enable = lib.mkDefault pkgs.stdenv.isDarwin;
  };
}
