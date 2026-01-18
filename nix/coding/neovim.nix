{
  pkgs,
  config,
  lib,
  helper,
  ...
}: let
  python-ghosttext-dependencies = pkgs.python3.withPackages (ps:
    with ps; [
      pynvim
      requests
      # nixpkgs has a different version of simple-websocket-server than on pypi
      (buildPythonPackage {
        pname = "simple-websocket-server";
        version = "0.4.4";
        format = "setuptools";
        src = pkgs.fetchFromGitHub {
          owner = "pikhovkin";
          repo = "simple-websocket-server";
          rev = "47a7dce556d22db483ec9c3db72b6c87736d8063";
          sha256 = "sha256-FlrYdT2wH6dj/72ELhfzwvfuoinhMy4/wEMEiQQp/ro=";
        };
        meta = with lib; {
          description = "A simple WebSocket server";
          homepage = "https://github.com/pikhovkin/simple-websocket-server";
          license = licenses.mit;
          platforms = platforms.all;
        };
      })
    ]);
in {
  options.neovim.enable = lib.mkEnableOption "neovim";
  config = lib.mkIf config.neovim.enable {
    home.sessionVariables.NVIM_GHOST_PYTHON_EXECUTABLE = lib.getExe python-ghosttext-dependencies;
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        extraPackages = [
          pkgs.gcc # tree-sitter
          pkgs.tree-sitter # tree-sitter
          pkgs.gnutar # tree-sitter
          pkgs.curl # tree-sitter
        ];
      };
      fish.functions = {
        n = helper.makeFishAliasFunction {
          body = "nvim $argv";
        };
      };
      mr.settings = {
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
  };
}
