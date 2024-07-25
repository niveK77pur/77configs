{
  pkgs,
  config,
  ...
}: {
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        pkgs.gcc # mostly for tree-sitter
      ];
    };
    programs.mr.settings = {
      ".config/nvim" = let
        url =
          {
            "ssh" = "git@github.com:niveK77pur/nvim.git";
            "https" = "https://github.com/niveK77pur/nvim";
          }
          ."${config.myrepos.cloneMode}";
      in {
        checkout = "git clone ${url} nvim";
      };
    };
  };
}
