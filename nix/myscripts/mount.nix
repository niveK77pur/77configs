{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mount;
  #  {{{
  pkg = {
    stdenvNoCC,
    makeWrapper,
    lib,
    libnotify,
    dmenu,
    smenu,
    coreutils,
    glib,
    mount,
    udisks,
    gnused,
    util-linux,
    usbutils,
    gnugrep,
    gawk,
  }:
    stdenvNoCC.mkDerivation rec {
      pname = "mount.sh";
      version = "1.0.0";

      src = ../../bin/${pname};
      unpackPhase = "ln -s $src $(stripHash $src)";

      runtimeDependencies = [
        libnotify
        dmenu
        smenu
        glib # for 'gio'
        mount
        udisks
        coreutils
        gnused
        util-linux
        usbutils
        gnugrep
        gawk
      ];

      buildInputs = [makeWrapper];

      installPhase = ''
        install -Dm755 ${pname} -t $out/bin
      '';

      postFixup = ''
        wrapProgram $out/bin/${pname} --set PATH ${lib.makeBinPath runtimeDependencies}
      '';

      meta = {
        description = "(Un-)mount USB devices";
      };
    };
  #  }}}
in {
  options.mount = {
    enable = lib.mkEnableOption "mount";
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

