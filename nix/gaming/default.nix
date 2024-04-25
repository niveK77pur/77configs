{lib, ...}: {
  imports = [
    ./steam.nix
    ./lutris.nix
    ./heroic.nix

    ./mangohud.nix
    ./gamemode.nix

    ./gpu-screen-recorder.nix
    ./ludusavi.nix

    ./vulkan.nix
    ./glx.nix
  ];
  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
      ];
  };
}
