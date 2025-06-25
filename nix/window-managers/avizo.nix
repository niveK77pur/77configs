{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.avizo;
in {
  options.avizo = {
    enable = lib.mkEnableOption "avizo";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.avizo;
      description = "avizo package";
    };
  };

  config = lib.mkIf cfg.enable {
    services.avizo = {
      enable = true;
      inherit (cfg) package;
    };
  };
}
