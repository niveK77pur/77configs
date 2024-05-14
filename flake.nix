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
  };

  outputs = {
    nixpkgs,
    home-manager,
    alejandra,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."kevin" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        ./nix/home.nix
        ./nix/coding
        ./nix/handy-tools
        ./nix/terminal
        ./nix/media
        ./nix/fonts
        ./nix/myscripts
        ./nix/gaming
        ./nix/browsing
        ./nix/system
        ./nix/messaging
        {
          config.wezterm.overrides = {
            window_background_opacity = 0.97;
            font_size = 11.1;
          };
          config.git = {
            userEmail = "kevinbiewesch@yahoo.fr";
            userName = "Kevin Laurent Biewesch";
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

    homeConfigurations."kuni" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./nix/home.nix
        ./nix/coding
        ./nix/handy-tools
        ./nix/terminal
        ./nix/media
        ./nix/fonts
        ./nix/myscripts
        ./nix/browsing
        ./nix/system
        ./nix/messaging
        {
          config.wezterm.overrides = {
            font_size = 9.5;
          };
          config.git = {
            userEmail = "kevinbiewesch@yahoo.fr";
            userName = "Kevin Laurent Biewesch";
          };
        }
      ];

      extraSpecialArgs = {
        inherit alejandra system;
        username = "kuni";
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        # python
        pkgs.ruff
        pkgs.isort

        # nix
        pkgs.nixd
        alejandra.defaultPackage.${system}
      ];
    };
  };
}
