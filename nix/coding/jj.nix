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
      type = lib.types.enum [
        "meld"
        ":builtin"
      ];
      default = ":builtin";
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
            inherit (cfg) diff-editor;
            default-command = [
              "log"
            ];
          };
          git = {
            private-commits = lib.strings.concatStringsSep " | " [
              "description(glob:'wip:*')"
              "description(glob:'private:*')"
            ];
          };
        };
      };
    }

    (lib.mkIf (cfg.diff-editor == "meld") {
      home.packages = [pkgs.meld];
    })
  ]);
}
