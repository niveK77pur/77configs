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
      };
    };
    # TODO: Enable shell integrations/completions?
    # See: https://jj-vcs.github.io/jj/latest/install-and-setup/#command-line-completion
  };
}
