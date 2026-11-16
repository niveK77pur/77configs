{
  stdenvNoCC,
  makeWrapper,
  lib,
  bash,
  bubblewrap,
  coreutils,
  pname ? "bwrap-ai",
  extraRuntimeInputs ? [],
  hookFile ? null,
}:
stdenvNoCC.mkDerivation rec {
  inherit pname;
  version = "1.0.0";

  src = ../../../bin/bwrap-ai;
  dontUnpack = true;

  runtimeDependencies =
    [
      bash
      bubblewrap
      coreutils
    ]
    ++ extraRuntimeInputs;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    install -Dm755 $src $out/bin/${pname}
    substituteInPlace $out/bin/${pname} \
      --replace-fail '#!/usr/bin/env nix-shell' "#!${lib.getExe bash}"
  '';

  postFixup = lib.concatStringsSep " " ([
      "wrapProgram"
      "$out/bin/${pname}"
      "--set PATH ${lib.makeBinPath runtimeDependencies} "
    ]
    ++ (lib.optional (hookFile != null) "--set BWRAP_HOOK_FILE ${lib.escapeShellArg (toString hookFile)}"));

  meta = {
    description = "Base bubblewrap configuration to sandbox AI programs";
    mainProgram = pname;
  };
}
