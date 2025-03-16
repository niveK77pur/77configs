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
