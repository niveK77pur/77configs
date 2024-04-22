{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    home.packages = [
      (pkgs.stdenv.mkDerivation rec {
        pname = "ccopy";
        version = "1.0.0";

        src = ../../bin;

        runtimeDependencies = with pkgs; [
          bash
          xclip
          coreutils
        ];

        buildInputs = [pkgs.makeWrapper];

        installPhase = ''
          install -Dm755 ${pname} -t $out/bin
        '';

        postFixup = ''
          wrapProgram $out/bin/${pname} --set PATH ${lib.makeBinPath runtimeDependencies}
        '';

        meta = {
          description = "Copy contents from terminal into clipboard (X11)";
        };
      })
    ];
  };
}
