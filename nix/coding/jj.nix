{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.jj;
in {
  options.jj = {
    enable = lib.mkEnableOption "jj";
    userEmail = lib.mkOption {
      type = lib.types.str;
    };
    userName = lib.mkOption {
      type = lib.types.str;
    };
    diff-editor = lib.mkOption {
      type = lib.types.enum [
        "meld"
        ":builtin"
      ];
      default = ":builtin";
      description = "Which diff editor to use, if any";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = [pkgs.jj-fzf];
      programs.fish.shellInit = ''
        # somehow executing 'jj-fzf' directly leads to problems (i.e. bookmark editing does not fill the input field)
        bind alt-j 'commandline "jj-fzf"; commandline -f execute; commandline -f repaint'
      '';
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            email = cfg.userEmail;
            name = cfg.userName;
          };
          ui = {
            inherit (cfg) diff-editor;
            default-command = [
              "log"
            ];
          };
          git = {
            private-commits =
              lib.strings.concatStringsSep " | "
              (map (revset: "(" + revset + ")") [
                "description(glob:'wip:*')"
                "description(glob:'private:*')"
                "empty() ~ merges() ~ root()" # an empty commit
              ]);
          };
          #  {{{1
          aliases = {
            newm = [
              "util"
              "exec"
              "--"
              (pkgs.writers.writeFish "jj-new-move-bookmark" (builtins.readFile ./jj/newm.fish))
            ];
            rebasem = [
              "util"
              "exec"
              "--"
              (pkgs.writers.writeFish "jj-rebase-move-bookmark" (builtins.readFile ./jj/rebasem.fish))
            ];
          }; #  }}}1
        };
      };
    }

    (lib.mkIf (cfg.diff-editor == "meld") {
      home.packages = [pkgs.meld];
    })
  ]);
}
# vim: fdm=marker

