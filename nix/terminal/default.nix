{
  config,
  lib,
  ...
}: {
  imports = [
    ./fish.nix
    ./wezterm
    ./rio.nix
    ./pistol.nix
    ./starship.nix
  ];

  options.terminal.enableAll = lib.mkEnableOption "terminal";

  config = lib.mkIf config.terminal.enableAll {
    fish.enable = lib.mkDefault true;
    wezterm.enable = lib.mkDefault true;
    rio.enable = lib.mkDefault true;
    pistol.enable = lib.mkDefault true;
    starship.enable = lib.mkDefault true;
  };
}
