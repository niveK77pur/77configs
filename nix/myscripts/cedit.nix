{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.cedit;
  #  {{{
  pkg = {
    stdenvNoCC,
    makeWrapper,
    lib,
    bash,
    xclip,
    coreutils,
    marktext,
    neovim,
    wezterm,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "cedit";
      version = "1.0.0";

      src = ../../bin/${pname};
      unpackPhase = "ln -s $src $(stripHash $src)";

      runtimeDependencies = [
        bash
        xclip
        coreutils
        marktext
        neovim
        wezterm
      ];

      buildInputs = [makeWrapper];

      installPhase = ''
        install -Dm755 ${pname} -t $out/bin
      '';

      postFixup = ''
        wrapProgram $out/bin/${pname} \
          --set PATH ${lib.makeBinPath runtimeDependencies} \
          --set TERMINAL ${wezterm}/bin/wezterm
      '';

      meta = {
        description = "Edit contents in clipboard (X11)";
      };
    };
  #  }}}
in {
  options.cedit = {
    enable = lib.mkEnableOption "cedit";
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

