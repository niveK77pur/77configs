{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.woof;
  woof = pkgs.callPackage ({
    stdenvNoCC,
    fetchFromCodeberg,
    installShellFiles,
    python3,
  }:
    stdenvNoCC.mkDerivation {
      name = "woof";
      version = "0.5";

      src = fetchFromCodeberg {
        owner = "nomis";
        repo = "woof";
        rev = "95e497e5c12ccb59f8ded3edb15301551f9d2476";
        hash = "sha256-WWPxkkPNJSa8eq7OAB+P1/UM5KE/JyhV4/dGeO7htN0=";
      };

      propagatedBuildInputs = [python3];
      nativeBuildInputs = [installShellFiles];

      installPhase = ''
        runHook preInstall

        install -Dm555 -t $out/bin woof
        installManPage doc/*

        runHook postInstall
      '';

      meta = {
        mainProgram = "woof";
        homepage = "https://codeberg.org/nomis/woof";
        description = "an ad-hoc single file webserver";
        license = lib.licenses.gpl2Plus;
      };
    }) {};
in {
  options.woof = {
    enable = lib.mkEnableOption "woof";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [woof];
  };
}
