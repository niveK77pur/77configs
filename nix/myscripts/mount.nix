{
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

  src = ../../bin;

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
}
