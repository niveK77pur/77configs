{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vidir.enable = lib.mkEnableOption "vidir";
  config = lib.mkIf config.vidir.enable {
    home.packages = [pkgs.perl5Packages.vidir];
  };
}
