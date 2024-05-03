{
  pkgs,
  alejandra,
  system,
  ...
}: {
  imports = [
    ./latex.nix
    ./git.nix
  ];
  config = {
    home.packages = with pkgs; [
      alejandra.defaultPackage.${system}
    ];

    programs.lazygit.enable = true;
    programs.ripgrep.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      # withNodeJs = true;
      # withPython3 = true;
    };
  };
}
