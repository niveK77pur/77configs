{pkgs, ...}: {
  imports = [
    ./aria2.nix
    ./lf.nix
    ./kde-connect.nix
    ./direnv.nix
    ./fd.nix
    ./atuin.nix
    ./viddy.nix
    ./zellij.nix
  ];
  config = {
    programs.lazygit.enable = true;
    programs.bat.enable = true;
    programs.ripgrep.enable = true;

    # TODO: replace with 'zoxide'?
    programs.z-lua = {
      enable = true;
      enableAliases = true;
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = true;
    };

    programs.fzf = {
      enable = true;
    };
  };
}
