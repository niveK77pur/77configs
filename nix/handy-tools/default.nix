{pkgs, ...}: {
  imports = [
    ./aria2.nix
    ./lf.nix
    ./kde-connect.nix
  ];
  config = {
    home.packages = [
      pkgs.fd
    ];

    programs.lazygit.enable = true;
    programs.bat.enable = true;
    programs.ripgrep.enable = true;

    # TODO: replace with 'zoxide'?
    programs.z-lua = {
      enable = true;
      enableAliases = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    programs.zellij = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = true;
    };

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
