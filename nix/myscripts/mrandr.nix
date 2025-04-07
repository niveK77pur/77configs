{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mrandr;
  #  {{{
  pkg = {
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
    };
  #  }}}
in {
  options.mrandr = {
    enable = lib.mkEnableOption "mrandr";
    OUTPUT = lib.mkOption {
      description = "Output display name from xrandr";
      type = lib.types.str;
    };
    SCREEN = lib.mkOption {
      description = "Main display name from xrandr";
      type = lib.types.str;
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage pkg {inherit (cfg) OUTPUT SCREEN;};
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
# vim: fdm=marker

