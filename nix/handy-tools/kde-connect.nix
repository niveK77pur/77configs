{pkgs, ...}: {
  config = {
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
