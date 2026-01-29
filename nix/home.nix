{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  config = {
    home = {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      inherit username;
      homeDirectory = "/${
        if pkgs.stdenv.isDarwin
        then "Users"
        else "home"
      }/${config.home.username}";

      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      stateVersion = "23.11"; # Please read the comment before changing.

      # Home Manager is pretty good at managing dotfiles. The primary way to manage
      # plain files is through 'home.file'.
      file = {
        # # Building this configuration will create a copy of 'dotfiles/screenrc' in
        # # the Nix store. Activating the configuration will then make '~/.screenrc' a
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;

        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
      };

      # Home Manager can also manage your environment variables through
      # 'home.sessionVariables'. If you don't want to manage your shell through Home
      # Manager then you have to manually source 'hm-session-vars.sh' located at
      # either
      #
      #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
      #
      # or
      #
      #  /etc/profiles/per-user/kevin/etc/profile.d/hm-session-vars.sh
      #
      sessionVariables = {
        # EDITOR = "emacs";
      };

      shell = {
        enableShellIntegration = true;
      };
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    services.home-manager.autoExpire = {
      enable = true;
    };

    # Let 'myrepos' handle this repository as well
    programs.mr.settings = {
      ".config/home-manager" = let
        url =
          {
            "ssh" = "git@github.com:niveK77pur/77configs.git";
            "https" = "https://github.com/niveK77pur/77configs.git";
          }
          ."${config.myrepos.cloneMode}";
      in {
        checkout = "git clone ${url} home-manager";
      };
    };

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "discord"
        "nvidia"
        "claude-code"
        "slack"
      ];
  };
}
