{
  config,
  lib,
  ...
}: {
  imports =
    map
    (file: ./. + "/${file}")
    (builtins.attrNames (
      lib.filterAttrs
      (_: value: value == "directory")
      (builtins.readDir ./.)
    ));

  options.categories.enableAll = lib.mkEnableOption "categories";

  config = lib.mkIf config.categories.enableAll {
    browsing.enableAll = lib.mkDefault true;
    coding.enableAll = lib.mkDefault true;
    fonts.enableAll = lib.mkDefault true;
    gaming.enableAll = lib.mkDefault true;
    handy-tools.enableAll = lib.mkDefault true;
    media.enableAll = lib.mkDefault true;
    messaging.enableAll = lib.mkDefault true;
    myscripts.enableAll = lib.mkDefault true;
    system.enableAll = lib.mkDefault true;
    terminal.enableAll = lib.mkDefault true;
    window-managers.enableAll = lib.mkDefault true;
  };
}
