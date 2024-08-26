{
  pkgs,
  lib,
  config,
  ...
}: {
  options.glx.enable = lib.mkEnableOption "glx" // {default = true;};
  config = lib.mkIf config.glx.enable {
    home.packages = with pkgs; [glxinfo];
  };
}
