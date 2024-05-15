{pkgs, ...}: {
  config = {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    services.gpg-agent.pinentryPackage = pkgs.pinentry-all;
    # home.packages = [pkgs.pinentry-all];
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
      };
    };
    programs.mr.settings = {
      ".password-store" = {
        checkout = "git clone git@github.com:niveK77pur/super-octo-succotash.git .password-store";
      };
    };
  };
}
