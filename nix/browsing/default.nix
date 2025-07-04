{
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
  ];

  options.browsing.enableAll = lib.mkEnableOption "browsing";

  config = lib.mkIf config.browsing.enableAll {
    firefox.enable = lib.mkDefault true;
  };
}
