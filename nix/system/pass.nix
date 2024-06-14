{pkgs, ...}: {
  config = {
    programs = {
      gpg.enable = true;
      password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
      };
      mr.settings = {
        ".password-store" = {
          checkout = "git clone git@github.com:niveK77pur/super-octo-succotash.git .password-store";
        };
      };
    };
    services.gpg-agent.enable = true;
    services.gpg-agent.pinentryPackage = pkgs.pinentry-all;
    # home.packages = [pkgs.pinentry-all];
  };
}
