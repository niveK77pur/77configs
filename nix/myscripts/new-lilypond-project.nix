{
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  lib,
  coreutils,
  gnugrep,
  gnused,
  findutils,
  lilypond,
  git,
  gh,
  openssh,
  useGh ? false,
}:
stdenvNoCC.mkDerivation rec {
  pname = "newlilypond_VIM.sh";
  version = "2024-05-10";

  src = fetchFromGitHub {
    owner = "niveK77pur";
    repo = "nvim";
    rev = "f31866f351e392024559c4f4be814f1b7d5ea522";
    sparseCheckout = [
      "scripts"
      "skeletons/Lilypond/newfile"
    ];
    sha256 = "sha256-Z99UWQM5/UbzXS09wkSrSBJ/7T82/usod7osRg5JHWo=";
  };

  buildInputs = [makeWrapper];

  runtimeDependencies =
    [
      lilypond
      coreutils
      gnugrep
      gnused
      findutils
      git
    ]
    ++ lib.lists.optionals useGh [
      gh
      openssh # if gh uses ssh
    ];

  patchPhase = ''
    substituteInPlace scripts/${pname} \
      --replace '$HOME/.config/nvim/skeletons/Lilypond/newfile' $out/skeleton
  '';

  installPhase = ''
    install -Dm755 scripts/${pname} -t $out/bin
    cp -r skeletons/Lilypond/newfile $out/skeleton
  '';

  postFixup = ''
    wrapProgram $out/bin/${pname} \
      --set PATH ${lib.makeBinPath runtimeDependencies}
  '';

  meta.description = "Helper script to set up a template Lilypond project for piano scores";
}
