{
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
    ./floorp.nix
  ];

  options.browsing.enableAll = lib.mkEnableOption "browsing";

  config = lib.mkIf config.browsing.enableAll {
    firefox.enable = lib.mkDefault true;
    floorp.enable = lib.mkDefault true;
  };
}
