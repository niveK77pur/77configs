{
  lib,
  config,
  ...
}: let
  cfg = config.jj;
in {
  options.jj = {
    enable = lib.mkEnableOption "jj";
    userEmail = lib.mkOption {
      type = lib.types.str;
    };
    userName = lib.mkOption {
      type = lib.types.str;
    };
    diff-editor = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [
        "meld"
      ]);
      default = null;
      description = "Which diff editor to use, if any";
    };
  };

  config = lib.mkIf config.jj.enable {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          email = cfg.userEmail;
          name = cfg.userName;
        };
        ui = {
          default-command = [
            "log"
          ];
        };
      };
    };
  };
}
