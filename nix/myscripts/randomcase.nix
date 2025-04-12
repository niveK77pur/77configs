{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.randomcase;
  #  {{{
  pkg = {
    stdenvNoCC,
    xclip,
    python3,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "randomcase.py";
      version = "1.0.0";

      src = ../../bin/${pname};
      unpackPhase = "ln -s $src $(stripHash $src)";

      runtimeDependencies = [
        xclip
        python3
      ];

      installPhase = "install -Dm755 ${pname} -t $out/bin";

      meta.description = "Apply random casing to text in clipboard";
    };
  #  }}}
in {
  options.randomcase = {
    enable = lib.mkEnableOption "randomcase";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage pkg {};
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
# vim: fdm=marker

