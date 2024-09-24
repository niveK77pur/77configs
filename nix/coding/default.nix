{
  config,
  lib,
  ...
}: {
  imports = [
    ./neovim.nix
    ./nix.nix
    ./latex.nix
    ./git.nix
    ./gh.nix
    ./lazygit.nix
    ./ripgrep.nix
  ];

  options.coding.enableAll = lib.mkEnableOption "coding";

  config = lib.mkIf config.coding.enableAll {
    neovim.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
    latex.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    gh.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
  };
}
