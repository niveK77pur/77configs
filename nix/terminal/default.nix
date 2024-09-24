{
  config,
  lib,
  ...
}: {
  imports = [
    ./fish.nix
    ./wezterm
    ./pistol.nix
    ./starship.nix
  ];

  options.terminal.enableAll = lib.mkEnableOption "terminal";

  config = lib.mkIf config.terminal.enableAll {
    fish.enable = lib.mkDefault true;
    wezterm.enable = lib.mkDefault true;
    pistol.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
  };
}
