{
  pkgs,
  lib,
  config,
  helper,
  ...
}: {
  options.fish.enable = lib.mkEnableOption "fish";
  config = let
    makeAlias = helper.makeFishAliasFunction;
  in
    lib.mkIf config.fish.enable {
      programs.fish = {
        enable = true;

        shellInit = ''
          set -Ux fifc_editor ${pkgs.neovim}/bin/nvim
        '';

        functions = lib.mkMerge [
          {
            fish_greeting = {
              body = "";
              description = "the greeting message printed on startup";
            };
          }

          {
            backup = {
              body = "${pkgs.coreutils}/bin/cp -r $filename $filename.(${pkgs.coreutils}/bin/date +%F-%T).bak";
              argumentNames = "filename";
              description = "Make a backup copy of the given file/directory";
            };
          }

          (lib.mkIf config.programs.feh.enable {
            feh = makeAlias {
              body = "feh -Z --scale-down $argv";
            };
          })

          (lib.mkIf config.programs.tmux.enable {
            t = makeAlias {
              body = "tmux $argv";
            };
            ta = makeAlias {
              body = "tmux attach $argv";
            };
            tat = makeAlias {
              body = "tmux attach -t $argv";
            };
            tk = makeAlias {
              body = "tmux kill-session -t $argv";
            };
            tl = makeAlias {
              body = "tmux ls $argv";
            };
            tn = makeAlias {
              body = "tmux new -s $argv";
            };
          })
        ];

        plugins = [
          {
            name = "fzf";
            src = pkgs.fetchFromGitHub {
              owner = "PatrickF1";
              repo = "fzf.fish";
              rev = "v10.3";
              sha512 = "sha512-PsX3/F4fHO2JCxsws14noGyQ9HMMRMQ2LWqy172Qm9kN+HMndK8NFyz6UDTaD9Zi2D1JTIZeEbQz4ARvTRBmoA==";
            };
          }
          {
            name = "fifc";
            src = pkgs.fetchFromGitHub {
              owner = "gazorby";
              repo = "fifc";
              rev = "a01650cd432becdc6e36feeff5e8d657bd7ee84a";
              sha512 = "sha512-LCRLrefPBZoFaR4t08Ilfyl0/L7p2O/AIWAZsqQqmORtBLyRnRWOdyLW8cGhY9gar2aYolHfWyadhO2Qku4myQ==";
            };
          }

          {
            name = "done";
            src = pkgs.fetchFromGitHub {
              owner = "franciscolourenco";
              repo = "done";
              rev = "1.19.3";
              sha512 = "sha512-OnrdZY4VVofo0h9KAyktmhw4xDi3UE2uA5c2HSx9u6+ts3OuixTdmSQd2/DqNYGzB/a4IVoKa8Wm2Xi9oCrx5A==";
            };
          }

          {
            name = "nix-env.fish";
            src = pkgs.fetchFromGitHub {
              owner = "lilyball";
              repo = "nix-env.fish";
              rev = "7b65bd2";
              sha512 = "sha512-qWpjZVWcSkkTOcF+5yik2YwlFYxWxLp28zVNhRKs8EqnIwGAvrxVDOB6nmhVT4D2MxygFbh51pzG2lQ8aI1ZGg==";
            };
          }

          {
            name = "loadenv.fish";
            src = pkgs.fetchFromGitHub {
              owner = "berk-karaal";
              repo = "loadenv.fish";
              rev = "5870891cd032a8eed594e7c024005bef5c7cefe2";
              sha512 = "sha512-I1+SkZ2ogF6wDEZwfCMCZNDsY4H9lDm6rAYwac13AzSCc8SqLwMw1gwAdzzEeJCG9nZF47FYwNEpWkdghNtM6A==";
            };
          }
        ];
      };
    };
}
