{
  stdenvNoCC,
  makeWrapper,
  lib,
  bash,
  xclip,
  coreutils,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ccopy";
  version = "1.0.0";

  src = ../../bin/${pname};
  unpackPhase = "ln -s $src $(stripHash $src)";

  runtimeDependencies = [
    bash
    xclip
    coreutils
  ];

  buildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 ${pname} -t $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/${pname} --set PATH ${lib.makeBinPath runtimeDependencies}
  '';

  meta = {
    description = "Copy contents from terminal into clipboard (X11)";
  };
}
