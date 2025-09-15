{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.new-lilypond-project;
  #  {{{
  pkg = {
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
      version = "2025-09-15";

      src = fetchFromGitHub {
        owner = "niveK77pur";
        repo = "nvim";
        rev = "c8aea453ecfba6017d7b5b9ca3203b6797b6bd50";
        sparseCheckout = [
          "scripts"
          "skeletons/Lilypond/newfile"
        ];
        sha256 = "sha256-kBBK4FcwaRPyVAUX1lDPHF9HdKRVSjWzcLCZGZORMjw=";
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
    };
  #  }}}
in {
  options.new-lilypond-project = {
    enable = lib.mkEnableOption "new-lilypond-project";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage pkg {
        useGh = config.programs.gh.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
# vim: fdm=marker

