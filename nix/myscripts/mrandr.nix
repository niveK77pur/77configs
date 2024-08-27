{
  stdenvNoCC,
  makeWrapper,
  lib,
  bash,
  coreutils,
  xrandr,
  dmenu,
  OUTPUT,
  SCREEN,
}:
stdenvNoCC.mkDerivation rec {
  pname = "mrandr.sh";
  version = "1.0.0";

  src = ../../bin/${pname};
  unpackPhase = "ln -s $src $(stripHash $src)";

  runtimeDependencies = [
    bash
    coreutils
    xrandr
    dmenu
  ];

  buildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 ${pname} -t $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/${pname} \
    --set PATH ${lib.makeBinPath runtimeDependencies} \
    --set OUTPUT ${OUTPUT} \
    --set SCREEN ${SCREEN} \
  '';

  meta = {
    description = "XRandR operations on specified display (X11)";
  };
}
