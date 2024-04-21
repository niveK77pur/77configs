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
    setConfigsRecursive = path:
      nixpkgs.lib.mkMerge (nixpkgs.lib.forEach (nixpkgs.lib.filesystem.listFilesRecursive path) (f: let
        fname = builtins.head (builtins.match ".*/config/(.*)" (toString f));
      in {
        "${fname}".source = f;
      }));
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
      ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        inherit alejandra system;
        inherit setConfigsRecursive;
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        ruff
        isort
      ];
    };
  };
}
