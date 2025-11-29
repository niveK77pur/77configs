{
  config,
  lib,
  ...
}: {
  imports =
    map
    (file: ./. + "/${file}")
    (lib.filter
      (f: f != "default.nix")
      (lib.attrNames (builtins.readDir ./.)));

  options.terminal.enableAll = lib.mkEnableOption "terminal";

  config = lib.mkIf config.terminal.enableAll {
    fish.enable = lib.mkDefault true;
    wezterm.enable = lib.mkDefault true;
    rio.enable = lib.mkDefault true;
    pistol.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
    ghostty.enable = lib.mkDefault true;
  };
}
