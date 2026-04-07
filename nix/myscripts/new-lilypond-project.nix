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
      version = "2025-10-19";

      src = ./new-lilypond-project;

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
        substituteInPlace ${pname} \
          --replace '$HOME/.config/nvim/skeletons/Lilypond/newfile' $out/skeleton
      '';

      installPhase = ''
        install -Dm755 ${pname} -t $out/bin
        cp -r skeleton $out
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

