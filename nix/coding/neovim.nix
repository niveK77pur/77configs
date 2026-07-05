{
  pkgs,
  config,
  lib,
  helper,
  ...
}: let
  #  {{{1
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
  # {{{1
  scmindent = pkgs.callPackage (
    {
      lib,
      stdenvNoCC,
      fetchFromGitHub,
      makeWrapper,
      lua5,
    }:
      stdenvNoCC.mkDerivation {
        name = "scmindent";
        version = "2022-07-06";

        src = fetchFromGitHub {
          owner = "ds26gte";
          repo = "scmindent";
          rev = "8c0fb12977fd7e63736963fd3e52d1dac359bc59";
          hash = "sha256-XjG5UHVd5Wf05P3Bdjzb6QE1A184q1FmVMNHR10YV9U=";
        };

        nativeBuildInputs = [makeWrapper];

        installPhase = ''
          runHook preInstall
          install -D scmindent.lua "$out/bin/scmindent.lua"
          runHook postInstall
        '';

        postInstall = ''
          wrapProgram "$out/bin/scmindent.lua" \
            --prefix PATH : ${lib.makeBinPath [lua5]}
        '';

        meta = {
          description = "Editing Lisp and Scheme files in vi";
          homepage = "https://github.com/ds26gte/scmindent";
          mainProgram = "scmindent.lua";
        };
      }
  ) {};
  #  }}}1
in {
  options.neovim.enable = lib.mkEnableOption "neovim";
  config = lib.mkIf config.neovim.enable {
    home.sessionVariables.NVIM_GHOST_PYTHON_EXECUTABLE = lib.getExe python-ghosttext-dependencies;
    programs = {
      neovim = {
        enable = true;
        sideloadInitLua = true;
        defaultEditor = true;
        extraPackages = [
          pkgs.gcc # tree-sitter
          pkgs.tree-sitter # tree-sitter
          pkgs.gnutar # tree-sitter
          pkgs.curl # tree-sitter
          pkgs.ltex-ls-plus
          pkgs.typos
          pkgs.cargo # parinfer-rust
          pkgs.rustc # parinfer-rust
          pkgs.fixjson
          scmindent
        ];
        withRuby = false;
        withPython3 = false;
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
# vim: fdm=marker

