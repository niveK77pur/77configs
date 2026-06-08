{
  lib,
  config,
  ...
}: let
  cfg = config.browsing;
in {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );
  options.browsing = {
    enableAll = lib.mkEnableOption "browsing";
    isServerConfiguration = lib.mkEnableOption "browsing server configuration" // {default = config.isServerConfiguration;};
  };

  config = lib.mkIf (cfg.enableAll && (!cfg.isServerConfiguration)) {
    firefox.enable = lib.mkDefault true;
  };
}
