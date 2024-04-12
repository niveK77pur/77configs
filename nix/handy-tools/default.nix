{pkgs, ...}: {
  config = {
    home.packages = [
      pkgs.fd
    ];

    programs.lf.enable = true;
    programs.aria2.enable = true;
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
