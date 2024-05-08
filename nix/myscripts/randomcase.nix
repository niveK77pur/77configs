{
  stdenvNoCC,
  xclip,
  python3,
}:
stdenvNoCC.mkDerivation rec {
  pname = "randomcase.py";
  version = "1.0.0";

  src = ../../bin;

  runtimeDependencies = [
    xclip
    python3
  ];

  installPhase = "install -Dm755 ${pname} -t $out/bin";

  meta.description = "Apply random casing to text in clipboard";
}
