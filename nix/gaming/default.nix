{
  config,
  lib,
  ...
}: {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );

  options.gaming = {
    enableAll = lib.mkEnableOption "gaming";
    devices = {
      enableAll = lib.mkEnableOption "gaming-devices";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.gaming.enableAll {
      chiaki.enable = lib.mkDefault true;
      gamemode.enable = lib.mkDefault true;
      gamescope.enable = lib.mkDefault true;
      gaming.devices.enableAll = lib.mkDefault true;
      glx.enable = lib.mkDefault true;
      gpu-screen-recorder.enable = lib.mkDefault true;
      heroic.enable = lib.mkDefault true;
      ludusavi.enable = lib.mkDefault true;
      lutris.enable = lib.mkDefault true;
      mangohud.enable = lib.mkDefault true;
      proton.enable = lib.mkDefault true;
      steam.enable = lib.mkDefault true;
      vulkan.enable = lib.mkDefault true;
    })

    (lib.mkIf config.gaming.devices.enableAll {
      playstation.enable = true;
    })
  ];
}
