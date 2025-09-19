{
  description = "Home Manager configuration of kevin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixgl,
    nix-index-database,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [nixgl.overlay];
    };
    git = {
      userEmail = "kevinbiewesch@yahoo.fr";
      userName = "Kevin Laurent Biewesch";
    };
    stylix-base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    #  {{{
    wrapNixGL = {
      binName,
      pkg ? pkgs.${binName},
      config,
    }:
      if config.home.withNixGL.enable
      then
        pkgs.writeShellScriptBin "${binName}" ''
          ${config.home.withNixGL.command} "${pkg}/bin/${binName}" "$@"
        ''
      else pkg;
    #  }}}
    #  {{{
    makeUser = user: modules: {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules =
          [
            nix-index-database.homeModules.nix-index
            ./nix/home.nix
            ./nix/categories.nix
          ]
          ++ modules;

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            system
            wrapNixGL
            inputs
            ;
          username = user;
        };
      };
    }; #  }}}
  in {
    homeConfigurations = pkgs.lib.mergeAttrsList [
      (makeUser "kevin" [
        {
          config = {
            categories.enableAll = true;
            mpv.withAnime4k = true;
            wezterm.overrides = {
              window_background_opacity = 0.97;
              font_size = 11.1;
            };
            git = {inherit (git) userName userEmail;};
            jj = {
              inherit (git) userName userEmail;
            };
            mrandr = {
              SCREEN = "eDP-2";
              OUTPUT = "DP-1";
            };
            swww.service = {
              enable = true;
              imagesDir = "/home/kevin/Pictures/Wallpaper";
            };
            sx.base16Scheme = stylix-base16Scheme;
            hyprland = {
              enable = true;
              monitor = [
                {
                  name = "eDP-1";
                  scale = 1.6;
                }
                {
                  name = "desc:Sony SONY TV  *00 0x01010101";
                  # resolution = "1920x1080@60";
                  scale = 2;
                  extraArgs = {
                    vrr = 3;
                  };
                }
              ];
            };
          };
        }
      ])

      (makeUser "kuni" [
        {
          config = {
            home.packages = [
              pkgs.bitwarden-desktop
              pkgs.google-cloud-sdk
            ];
            claude.enable = true;
            services.ssh-agent.enable = true;
            firefox = {
              enableKyomeiProfile = true;
              defaultProfile = "kyomei";
            };
            slack.enable = true;
            glab.enable = true;
            categories.enableAll = true;
            gaming.enableAll = false;
            home.withNixGL = rec {
              enable = true;
              package = pkgs.nixgl.nixGLIntel;
              command = "${package}/bin/nixGLIntel";
            };
            wezterm.overrides = {
              font_size = 9.5;
            };
            zathura.withLilypondXdgOpen = true;
            git = {inherit (git) userName userEmail;};
            jj = {
              inherit (git) userName userEmail;
            };
            mrandr = {
              SCREEN = "eDP";
              OUTPUT = "DisplayPort-0";
            };
            swww.service = {
              enable = true;
              imagesDir = "/home/kuni/Pictures/i3wallpapers/active";
            };
            sx.base16Scheme = stylix-base16Scheme;
            hyprland = {
              enable = true;
              monitor = [
                {
                  name = "eDP-1";
                  scale = 1.6;
                }
                {
                  name = "DP-1"; # TODO: Make sure it matches monitor by name and ID
                  position = "auto-left";
                  scale = 1 + 1.0 / 3;
                }
                {
                  name = "HDMI-A-1";
                  position = "auto-up";
                }
                {
                  name = "desc:LG Electronics LG ULTRAFINE 0x00015B5D";
                  position = "auto-up";
                  scale = 1.6;
                }
              ];
            };
            programs.hyprlock.package = null; # nixpkgs hyprlock does not respect Fedora PAM config
          };
        }
      ])

      (makeUser "ubuntu" [
        {
          config = {
            coding.enableAll = true;
            handy-tools.enableAll = true;
            system.enableAll = true;
            terminal.enableAll = true;
            latex.enable = true;
            git = {inherit (git) userName userEmail;};
            jj = {inherit (git) userName userEmail;};
          };
        }
      ])

      (makeUser "kbiewesch" [
        {
          config = {
            coding.enableAll = true;
            handy-tools.enableAll = true;
            kdeconnect.enable = false;
            fish.enable = true;
            ghostty = {
              enable = true;
              package = null;
            };
            starship.enable = true;
            git = {inherit (git) userName userEmail;};
            jj = {inherit (git) userName userEmail;};
            autoraise.enable = true;
          };
        }
      ])
    ];

    devShells.${system}.default = pkgs.mkShell {
      name = "home-manager";
      packages = [
        # python
        pkgs.ruff
        pkgs.isort
        pkgs.basedpyright

        # nix
        pkgs.nixd
        pkgs.nil
        pkgs.alejandra
        pkgs.statix

        pkgs.fish-lsp
      ];
    };
  };
}
# vim: fdm=marker

