{
  config,
  lib,
  ...
}: let
  cfg = config.messaging;
in {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );
  options.messaging = {
    enableAll = lib.mkEnableOption "messaging";
    isServerConfiguration = lib.mkEnableOption "messaging server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf (cfg.enableAll && (!cfg.isServerConfiguration)) {
    discord.enable = lib.mkDefault true;
    ferdium.enable = lib.mkDefault true;
    signal.enable = lib.mkDefault true;
    thunderbird.enable = lib.mkDefault true;
  };
}
