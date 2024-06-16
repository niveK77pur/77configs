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
    ./ripgrep.nix
  ];
  config = {
    home.packages = [
      alejandra.defaultPackage.${system}
      pkgs.nixd
      pkgs.statix
    ];
  };
}
