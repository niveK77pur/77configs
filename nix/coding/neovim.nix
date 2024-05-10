{pkgs, ...}: {
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        pkgs.gcc # mostly for tree-sitter
      ];
    };
  };
}
