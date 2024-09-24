{
  config,
  lib,
  ...
}: {
  imports = [
    ./discord.nix
    ./ferdium.nix
    ./thunderbird.nix
  ];

  options.messaging.enableAll = lib.mkEnableOption "messaging";

  config = lib.mkIf config.messaging.enableAll {
    discord.enable = lib.mkDefault true;
    ferdium.enable = lib.mkDefault true;
    thunderbird.enable = lib.mkDefault true;
  };
}
