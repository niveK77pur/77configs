{
  description = "Home Manager configuration of kevin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:nix-community/nixGL";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww.url = "github:LGFae/swww";
  };

  outputs = {
    nixpkgs,
    home-manager,
    alejandra,
    nixgl,
    nix-index-database,
    swww,
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
    #  {{{
    makeUser = user: modules: {
      "${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules =
          [
            nix-index-database.hmModules.nix-index
            ./nix/home.nix
            ./nix/categories.nix
          ]
          ++ modules;

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit
            alejandra
            system
            swww
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
              diff-editor = "meld";
            };
            mrandr = {
              SCREEN = "eDP-2";
              OUTPUT = "DP-1";
            };
            home.withNixGL = rec {
              enable = true;
              package = pkgs.nixgl.auto.nixGLDefault;
              command = "${package}/bin/nixGL";
            };
            swww.service = {
              enable = false;
            };
          };
        }
      ])

      (makeUser "kuni" [
        {
          config = {
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
            git = {inherit (git) userName userEmail;};
            jj = {
              inherit (git) userName userEmail;
              diff-editor = "meld";
            };
            mrandr = {
              SCREEN = "eDP";
              OUTPUT = "DisplayPort-0";
            };
            swww.service = {
              enable = true;
              imagesDir = "/home/kuni/Pictures/i3wallpapers/active";
            };
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
              ];
            };
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
        alejandra.defaultPackage.${system}
        pkgs.statix
      ];
    };
  };
}
# vim: fdm=marker

