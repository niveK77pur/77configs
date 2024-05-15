{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  options.home = {
    withNixGL = {
      enable = lib.mkEnableOption {
        default = false;
        description = "Whether to use NixGL";
      };
      package = lib.mkOption {
        # IMPORTANT: The `.auto` will require an `--impure` evaluation
        default = pkgs.nixgl.auto.nixGLDefault;
        type = lib.types.package;
        description = "Which NixGL package to include for working with OpenGL applications";
      };
      command = lib.mkOption {
        default = "${config.home.withNixGL.package}/bin/nixGL";
        type = lib.types.str;
        description = "Path to the NixGL Command, needed to create wrappers for applications";
      };
    };
  };

  config = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = username;
    home.homeDirectory = "/home/${config.home.username}";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = lib.lists.optional (config.home.withNixGL.enable) config.home.withNixGL.package;

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
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
    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "discord"
      ];
  };
}
