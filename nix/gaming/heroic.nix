{
  pkgs,
  lib,
  config,
  ...
}: {
  options.heroic.enable = lib.mkEnableOption "heroic";
  config = lib.mkIf config.heroic.enable {
    home.packages = with pkgs; [heroic];
  };
}
