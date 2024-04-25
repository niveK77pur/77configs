{pkgs, ...}: {
  imports = [
    ./aria2.nix
    ./lf.nix
    ./kde-connect.nix
    ./direnv.nix
    ./fd.nix
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

    programs.zellij = {
      enable = true;
    };

    programs.atuin = {
      enable = true;
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
