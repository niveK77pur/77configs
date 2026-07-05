{
  stdenv,
  lib,
  makeWrapper,
  chicken,
  chickenPackages,
  fzf,
}:
stdenv.mkDerivation rec {
  name = "claude-resume-global";
  version = "0.0.1";

  src = ./claude-resume-global.scm;

  nativeBuildInputs = [
    makeWrapper
    chicken
    chickenPackages.chickenEggs.medea
    chickenPackages.chickenEggs.args
  ];

  unpackPhase = ''
    runHook preUnpack
    cp ${src} ${name}.scm
    runHook postUnpack
  '';

  buildPhase = ''
    csc -static -output-file ${name}{,.scm}
  '';

  installPhase = ''
    runHook preInstall
    install -D ${name} $out/bin/${name}
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/${name} \
      --set FZF_CMD "${lib.getExe fzf}"
  '';

  meta.mainProgram = name;
}
