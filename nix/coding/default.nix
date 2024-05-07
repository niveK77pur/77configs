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
    ./lazygit.nix
  ];
  config = {
    home.packages = with pkgs; [
      alejandra.defaultPackage.${system}
      nixd
    ];

    programs.ripgrep.enable = true;
  };
}
