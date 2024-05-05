{
  pkgs,
  alejandra,
  system,
  ...
}: {
  imports = [
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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      # withNodeJs = true;
      # withPython3 = true;
    };
  };
}
