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
