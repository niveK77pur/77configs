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
      pkgs.statix
    ];

    programs.ripgrep.enable = true;
  };
}
