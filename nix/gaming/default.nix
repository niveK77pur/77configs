{
  config,
  lib,
  ...
}: {
  imports = [
    ./steam.nix
    ./lutris.nix
    ./heroic.nix

    ./mangohud.nix
    ./gamemode.nix
    ./gamescope.nix

    ./gpu-screen-recorder.nix
    ./ludusavi.nix

    ./vulkan.nix
    ./glx.nix

    ./devices

    ./chiaki.nix
  ];

  options.gaming.enableAll = lib.mkEnableOption "gaming";

  config = lib.mkIf config.gaming.enableAll {
    steam.enable = lib.mkDefault true;
    lutris.enable = lib.mkDefault true;
    heroic.enable = lib.mkDefault true;

    mangohud.enable = lib.mkDefault true;
    gamemode.enable = lib.mkDefault true;
    gamescope.enable = lib.mkDefault true;

    gpu-screen-recorder.enable = lib.mkDefault true;
    ludusavi.enable = lib.mkDefault true;

    vulkan.enable = lib.mkDefault true;
    glx.enable = lib.mkDefault true;

    gaming.devices.enableAll = lib.mkDefault true;
    chiaki.enable = lib.mkDefault true;
  };
}
