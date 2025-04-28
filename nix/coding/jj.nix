{
  pkgs,
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

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
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
    }

    (lib.mkIf (cfg.diff-editor == "meld") {
      home.packages = [pkgs.meld];
      programs.jujutsu.settings.ui.diff-editor = "meld-3";
    })
  ]);
}
