{
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
    ./vieb.nix
  ];

  options.browsing.enableAll = lib.mkEnableOption "browsing";

  config = lib.mkIf config.browsing.enableAll {
    firefox.enable = lib.mkDefault true;
    vieb.enable = lib.mkDefault true;
  };
}
