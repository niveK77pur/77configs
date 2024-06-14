{
  pkgs,
  alejandra,
  system,
  ...
}: {
  imports = [
    ./neovim.nix
    ./latex.nix
    ./git.nix
    ./gh.nix
    ./lazygit.nix
  ];
  config = {
    home.packages = [
      alejandra.defaultPackage.${system}
      pkgs.nixd
    ];

    programs.ripgrep.enable = true;
  };
}
