{
  pkgs,
  lib,
  config,
  ...
}: {
  options.vidir.enable = lib.mkEnableOption "vidir" // {default = true;};
  config = lib.mkIf config.vidir.enable {
    home.packages = [pkgs.perl538Packages.vidir];
  };
}
