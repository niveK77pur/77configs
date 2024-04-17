{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    home.packages = [
      (pkgs.stdenv.mkDerivation rec {
        pname = "we";
        version = "1.0.0";

        src = ../../bin;

        runtimeDependencies = with pkgs; [
          mpv
          python3
        ];

        buildInputs = [pkgs.makeWrapper];

        installPhase = ''
          install -Dm755 we -t $out/bin
        '';

        postFixup = ''
          wrapProgram $out/bin/we --set PATH ${lib.makeBinPath runtimeDependencies}
        '';

        meta = {
          description = "Helper to watch episodes using MPV";
        };
      })
    ];
  };
}
