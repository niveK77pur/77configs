{
  pkgs,
  lib,
  config,
  ...
}: {
  options.pass.enable = lib.mkEnableOption "pass";
  config = lib.mkIf config.pass.enable {
    programs = {
      gpg.enable = true;
      password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
      };
      mr.settings = {
        ".password-store" = let
          url =
            {
              "ssh" = "git@github.com:niveK77pur/super-octo-succotash.git";
              "https" = "https://github.com/niveK77pur/super-octo-succotash.git";
            }
            ."${config.myrepos.cloneMode}";
        in {
          checkout = "git clone ${url} .password-store";
        };
      };
    };
    services.gpg-agent.enable = true;
    services.gpg-agent.pinentry.package = pkgs.pinentry-all;
    # home.packages = [pkgs.pinentry-all];
  };
}
