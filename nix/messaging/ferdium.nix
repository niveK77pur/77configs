{
  pkgs,
  lib,
  config,
  ...
}: {
  options.ferdium.enable = lib.mkEnableOption "ferdium" // {default = true;};
  config = lib.mkIf config.ferdium.enable {
    home.packages = [pkgs.ferdium];
  };
}
