{
  pkgs,
  lib,
  config,
  ...
}: {
  options.dua.enable = lib.mkEnableOption "dua";
  config = lib.mkIf config.dua.enable {
    home.packages = [pkgs.dua];
  };
}
