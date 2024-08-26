{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gpu-screen-recorder.enable = lib.mkEnableOption "gpu-screen-recorder" // {default = true;};
  config = lib.mkIf config.gpu-screen-recorder.enable {
    home.packages = with pkgs; [
      gpu-screen-recorder
      gpu-screen-recorder-gtk
    ];
  };
}
