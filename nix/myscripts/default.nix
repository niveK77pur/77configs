{
  lib,
  config,
  ...
}: let
  cfg = config.myscripts;
in {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file:
      (file.hasExt "nix")
      && (file.name != "default.nix")
      && (file.name != "mount-go.nix"))
    ./.
  );

  options.myscripts = {
    enableAll = lib.mkEnableOption "myscripts";
  };

  config = lib.mkIf cfg.enableAll {
    ccopy.enable = lib.mkDefault true;
    cedit.enable = lib.mkDefault true;
    mount.enable = lib.mkDefault true;
    mrandr.enable = lib.mkDefault true;
    new-lilypond-project.enable = lib.mkDefault true;
    randomcase.enable = lib.mkDefault true;
    we.enable = lib.mkDefault true;
  };
}
