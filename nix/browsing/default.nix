{
  lib,
  config,
  ...
}: {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );

  options.browsing.enableAll = lib.mkEnableOption "browsing";

  config = lib.mkIf config.browsing.enableAll {
    firefox.enable = lib.mkDefault true;
  };
}
