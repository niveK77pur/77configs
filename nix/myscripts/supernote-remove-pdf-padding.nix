{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.supernote-remove-pdf-padding;
  pkg = {
    stdenvNoCC,
    makeWrapper,
    python3,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "supernote-remove-pdf-padding";
      version = "0.0.1";

      src = ../../bin/supernote-remove-pdf-padding.py;
      unpackPhase = "cp -a $src $(stripHash $src)";

      nativeBuildInputs = [makeWrapper];

      installPhase = ''
        runHook preInstall

        install -Dm 555 "$(stripHash $src)" $out/bin/${meta.mainProgram}
        wrapProgram $out/bin/${meta.mainProgram} \
          --set PATH ${lib.makeBinPath [(python3.withPackages (ps: with ps; [pypdf]))]} \

        runHook postInstall
      '';

      meta = {
        description = "Remove padding from Supernote exported PDF documents";
        mainProgram = pname;
      };
    };
in {
  options.supernote-remove-pdf-padding = {
    enable = lib.mkEnableOption "supernote-remove-pdf-padding";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage pkg {};
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
