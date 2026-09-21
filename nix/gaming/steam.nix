{
  pkgs,
  lib,
  config,
  ...
}: {
  options.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf config.steam.enable {
    home.packages = with pkgs; [
      (steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libxcursor
            libxi
            libxinerama
            libxscrnsaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      })
    ];
  };
}
