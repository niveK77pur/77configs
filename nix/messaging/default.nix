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

  options.messaging.enableAll = lib.mkEnableOption "messaging";

  config = lib.mkIf config.messaging.enableAll {
    discord.enable = lib.mkDefault true;
    ferdium.enable = lib.mkDefault true;
    signal.enable = lib.mkDefault true;
    thunderbird.enable = lib.mkDefault true;
  };
}
