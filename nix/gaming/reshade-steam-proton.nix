{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.reshade-steam-proton;
  reshade-steam-proton = pkgs.callPackage (
    {
      stdenvNoCC,
      fetchFromGitHub,
      makeWrapper,
      curl,
      git,
      gnugrep,
      p7zip,
      protontricks,
      wget,
      wineWow64Packages,
    }:
      stdenvNoCC.mkDerivation rec {
        pname = "reshade-steam-proton";
        version = "2023-04-22";

        src = fetchFromGitHub {
          owner = "kevinlekiller";
          repo = "reshade-steam-proton";
          rev = "55d4a681c9389e20ab569234f01bf67dbd6866a7";
          hash = "sha256-jVqeVIW5cIgRkK/V3HxN1RKcRb+LaFR7n8GHxvowW0I=";
        };

        nativeBuildInputs = [makeWrapper];
        buildInputs = [
          curl
          git
          gnugrep
          p7zip
          protontricks
          wget
          wineWow64Packages.stable
        ];

        installPhase = ''
          runHook preInstall

          install -Dm 555 -t $out/bin *.sh

          runHook postInstall
        '';

        postInstall = ''
          for p in $out/bin/*.sh; do
            wrapProgram "$p" \
              --prefix PATH : ${lib.makeBinPath buildInputs}
          done
        '';
      }
  ) {};
in {
  options.reshade-steam-proton = {
    enable = lib.mkEnableOption "reshade-steam-proton";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [reshade-steam-proton];
  };
}
