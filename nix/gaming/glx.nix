{
  pkgs,
  lib,
  config,
  ...
}: {
  options.glx.enable = lib.mkEnableOption "glx";
  config = lib.mkIf config.glx.enable {
    home.packages = with pkgs; [mesa-demos];
  };
}
