{
  config,
  lib,
  ...
}: {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );

  options.system.enableAll = lib.mkEnableOption "system";

  config = lib.mkIf config.system.enableAll {
    topgrade.enable = lib.mkDefault true;
    pass.enable = lib.mkDefault true;
    myrepos.enable = lib.mkDefault true;
  };
}
