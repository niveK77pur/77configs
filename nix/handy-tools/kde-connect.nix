{
  pkgs,
  lib,
  config,
  ...
}: {
  options.kdeconnect.enable = lib.mkEnableOption "kdeconnect";
  config = lib.mkIf config.kdeconnect.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # Configure Firefox in /etx/nixos/configuration.nix if KDE Connect does not work
    # networking.firewall = {
    #   enable = true;
    #   allowedTCPPortRanges = [
    #     {
    #       from = 1714;
    #       to = 1764;
    #     } # KDE Connect
    #   ];
    #   allowedUDPPortRanges = [
    #     {
    #       from = 1714;
    #       to = 1764;
    #     } # KDE Connect
    #   ];
    # };
  };
}
