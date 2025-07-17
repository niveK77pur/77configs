{
  pkgs,
  lib,
  config,
  ...
}: {
  options.fish.enable = lib.mkEnableOption "fish";
  config = let
    makeAlias = args:
      args
      // {
        wraps = args.body;
        description =
          "alias: "
          + (args.description or args.body);
      };
  in
    lib.mkIf config.fish.enable {
      programs.fish = {
        enable = true;

        shellInit = ''
          # lfcd
          bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
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

          {
            # see: https://github.com/gokcehan/lf/blob/master/etc/lfcd.fish
            lfcd = {
              body = ''cd "$(command ${pkgs.lf}/bin/lf -print-last-dir $argv)"'';
              wraps = "${pkgs.lf}/bin/lf";
              description = "lf - Terminal file manager (changing directory on exit)";
            };
          }

          (lib.mkIf config.programs.neovim.enable {
            n = makeAlias {
              body = "nvim $argv";
            };
            v = makeAlias {
              body = "nvim $argv";
            };
          })

          (lib.mkIf config.programs.feh.enable {
            feh = makeAlias {
              body = "feh -Z --scale-down $argv";
            };
          })

          (lib.mkIf config.programs.lazygit.enable {
            lg = makeAlias {
              body = "lazygit $argv";
            };
          })

          (lib.mkIf config.lazyjj.enable {
            lj = makeAlias {
              body = "lazyjj $argv";
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

        shellAbbrs = lib.mkMerge [
          (lib.mkIf config.programs.jujutsu.enable {
            jjl = {
              position = "command";
              expansion = ''jj log -n (math "floor($(${pkgs.ncurses}/bin/tput lines) / 2)" - 2)'';
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
        ];
      };
    };
}
