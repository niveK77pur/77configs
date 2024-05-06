{
  stdenvNoCC,
  makeWrapper,
  lib,
  bash,
  xclip,
  coreutils,
  marktext,
  neovim,
  wezterm,
}:
stdenvNoCC.mkDerivation rec {
  pname = "cedit";
  version = "1.0.0";

  src = ../../bin;

  runtimeDependencies = [
    bash
    xclip
    coreutils
    marktext
    neovim
    wezterm
  ];

  buildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 ${pname} -t $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${lib.makeBinPath runtimeDependencies} \
      --set TERMINAL ${wezterm}/bin/wezterm
  '';

  meta = {
    description = "Edit contents in clipboard (X11)";
  };
}
