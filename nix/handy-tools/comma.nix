{
  pkgs,
  lib,
  config,
  ...
}: {
  options.comma.enable = lib.mkEnableOption "comma";
  config = lib.mkIf config.comma.enable {
    home.packages = [pkgs.comma];
  };
}
