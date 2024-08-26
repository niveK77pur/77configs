{
  pkgs,
  lib,
  config,
  ...
}: {
  options.heroic.enable = lib.mkEnableOption "heroic" // {default = true;};
  config = lib.mkIf config.heroic.enable {
    home.packages = with pkgs; [heroic];
  };
}
