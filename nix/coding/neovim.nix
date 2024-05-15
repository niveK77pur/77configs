{pkgs, ...}: {
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        pkgs.gcc # mostly for tree-sitter
      ];
    };
    programs.mr.settings = {
      ".config/nvim" = {
        checkout = "git clone git@github.com:niveK77pur/nvim.git nvim";
      };
    };
  };
}
