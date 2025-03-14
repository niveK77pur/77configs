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
  };

  outputs = {
    nixpkgs,
    home-manager,
    alejandra,
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
  in {
    homeConfigurations = {
      "kevin" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          nix-index-database.hmModules.nix-index
          ./nix/home.nix
          ./nix/categories.nix
          {
            config = {
              categories.enableAll = true;
              mpv.withAnime4k = true;
              wezterm.overrides = {
                window_background_opacity = 0.97;
                font_size = 11.1;
              };
              git = {inherit (git) userName userEmail;};
              jj = {inherit (git) userName userEmail;};
              myscripts.mrandr = {
                SCREEN = "eDP-2";
                OUTPUT = "DP-1";
              };
            };
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit alejandra system;
          username = "kevin";
        };
      };

      "kuni" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.hmModules.nix-index
          ./nix/home.nix
          ./nix/categories.nix
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
              jj = {inherit (git) userName userEmail;};
              myscripts.mrandr = {
                SCREEN = "eDP";
                OUTPUT = "DisplayPort-0";
              };
            };
          }
        ];

        extraSpecialArgs = {
          inherit alejandra system;
          username = "kuni";
        };
      };

      "ubuntu" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.hmModules.nix-index
          ./nix/home.nix
          ./nix/categories.nix
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
        ];

        extraSpecialArgs = {
          inherit alejandra system;
          username = "ubuntu";
        };
      };
    };

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
