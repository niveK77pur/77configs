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
    nix-index-database,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    inherit (pkgs) lib;
    git = {
      userEmail = "kevinbiewesch@yahoo.fr";
      userName = "Kevin Laurent Biewesch";
    };
    stylix-base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
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
        extraSpecialArgs = let
          helper = {
            # Create a cleaner alias for fish using a function
            makeFishAliasFunction = args:
              args
              // {
                wraps = args.body;
                description =
                  "alias: "
                  + (args.description or args.body);
              };
          };
        in {
          inherit
            system
            inputs
            helper
            ;
          username = user;
        };
      };
    }; #  }}}
  in {
    homeConfigurations =
      lib.mergeAttrsList
      (map
        (f:
          makeUser (lib.removeSuffix ".nix" (baseNameOf f)) (pkgs.callPackage f {
            inherit
              git
              stylix-base16Scheme
              inputs
              ;
          }))
        (lib.fileset.toList ./homeConfigurations));

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

