{
  pkgs,
  config,
  lib,
  helper,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "neovim";
  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraPackages = [
        pkgs.gcc # mostly for tree-sitter
      ];
    };
    programs.fish.functions = {
      n = helper.makeFishAliasFunction {
        body = "nvim $argv";
      };
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
