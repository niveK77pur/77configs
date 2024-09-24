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
    programs.git = {
      enable = true;
      inherit (cfg) userEmail userName;
      # delta.enable = true;
      diff-so-fancy.enable = true;
      # difftastic.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
