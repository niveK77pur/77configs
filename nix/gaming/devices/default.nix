{
  config,
  lib,
  ...
}: {
  imports = [
    ./playstation.nix
  ];

  options.gaming.devices.enableAll = lib.mkEnableOption "gaming-devices";

  config = lib.mkIf config.gaming.devices.enableAll {
    playstation.enable = true;
  };
}
