{
  lib,
  config,
  ...
}: let
  cfg = config.git;
in {
  options.git = {
    enable = lib.mkEnableOption "git";
    userEmail = lib.mkOption {
      type = lib.types.str;
    };
    userName = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.git.enable {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            email = cfg.userEmail;
            name = cfg.userName;
          };
          init.defaultBranch = "main";
        };
      };
      # delta.enable = true;
      diff-so-fancy.enable = true;
      # difftastic.enable = true;
    };
  };
}
