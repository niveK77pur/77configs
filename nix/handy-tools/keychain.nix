{
  lib,
  config,
  ...
}: let
  cfg = config.keychain;
in {
  options.keychain = {
    enable = lib.mkEnableOption "keychain";
    keys = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    programs.keychain = {
      enable = true;
      inherit (cfg) keys;
    };
  };
}
