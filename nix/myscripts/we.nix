{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.we;
  #  {{{
  pkg = {
    stdenvNoCC,
    makeWrapper,
    lib,
    mpv,
    python3,
    anime4kProfileName ? null,
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

      postFixup = lib.strings.concatStringsSep " " [
        "wrapProgram $out/bin/we"
        "--set PATH ${lib.makeBinPath runtimeDependencies}"
        (lib.strings.optionalString (!builtins.isNull anime4kProfileName) "--set MPV_PROFILE ${anime4kProfileName}")
      ];

      meta = {
        description = "Helper to watch episodes using MPV";
      };
    };
  #  }}}
in {
  options.we = {
    enable = lib.mkEnableOption "we";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage pkg (lib.mergeAttrsList [
        {mpv = config.programs.mpv.finalPackage;}
        (lib.attrsets.optionalAttrs config.mpv.withAnime4k {
          inherit (config.mpv) anime4kProfileName;
        })
      ]);
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
# vim: fdm=marker

