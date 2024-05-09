{
  stdenvNoCC,
  makeWrapper,
  lib,
  mpv,
  python3,
}:
stdenvNoCC.mkDerivation rec {
  pname = "we";
  version = "1.0.0";

  src = ../../bin/${pname};
  unpackPhase = "ln -s $src $(stripHash $src)";

  runtimeDependencies = [
    mpv
    python3
  ];

  buildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 we -t $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/we --set PATH ${lib.makeBinPath runtimeDependencies}
  '';

  meta = {
    description = "Helper to watch episodes using MPV";
  };
}
