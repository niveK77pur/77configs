{
  pkgs,
  config,
  lib,
  ...
}: {
  options.parallel.enable = lib.mkEnableOption "parallel";

  config = lib.mkIf config.parallel.enable {
    home.packages = [pkgs.parallel];
  };
}
