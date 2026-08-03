{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.supernote-remove-pdf-padding;
  pkg = {python3Packages}:
    python3Packages.buildPythonApplication rec {
      pname = "supernote-remove-pdf-padding";
      version = "0.0.1";

      src = ../../bin/supernote-remove-pdf-padding.py;
      dontUnpack = true;
      pyproject = false;

      propagatedBuildInputs = with python3Packages; [
        pypdf
      ];

      installPhase = ''
        runHook preInstall

        install -Dm 555 "$src" $out/bin/${meta.mainProgram}

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
