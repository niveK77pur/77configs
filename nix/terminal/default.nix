{
  config,
  lib,
  ...
}: let
  cfg = config.terminal;
in {
  imports =
    map
    (file: ./. + "/${file}")
    (lib.filter
      (f: f != "default.nix")
      (lib.attrNames (builtins.readDir ./.)));

  options.terminal = {
    enableAll = lib.mkEnableOption "terminal";
    isServerConfiguration = lib.mkEnableOption "terminal server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf cfg.enableAll {
    fish.enable = lib.mkDefault true;
    ghostty.enable = lib.mkDefault (!cfg.isServerConfiguration);
    rio.enable = lib.mkDefault (!cfg.isServerConfiguration);
    starship.enable = lib.mkDefault true;
    wezterm.enable = lib.mkDefault (!cfg.isServerConfiguration);
  };
}
