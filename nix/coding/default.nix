{
  config,
  lib,
  ...
}: {
  imports = [
    ./neovim.nix
    ./nix-tools.nix
    ./latex.nix
    ./git.nix
    ./jj.nix
    ./gh.nix
    ./lazygit.nix
    ./ripgrep.nix
    ./lazyjj.nix
  ];

  options.coding.enableAll = lib.mkEnableOption "coding";

  config = lib.mkIf config.coding.enableAll {
    neovim.enable = lib.mkDefault true;
    nix-tools.enable = lib.mkDefault true;
    latex.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    jj.enable = lib.mkDefault true;
    gh.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
    layzjj.enable = lib.mkDefault true;
  };
}
