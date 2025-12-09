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
      delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };
      programs = {
        fish = {
          shellInit = ''
            # somehow executing 'jj-fzf' directly leads to problems (i.e. bookmark editing does not fill the input field)
            bind alt-j 'commandline "jj-fzf"; commandline -f execute; commandline -f repaint'
          '';
          shellAbbrs = {
            jjl = {
              position = "command";
              expansion = ''jj log -n (math "floor($(${pkgs.ncurses}/bin/tput lines) / 2)" - 2)'';
            };
          };
        };
        jujutsu = {
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
            aliases = lib.mergeAttrsList [
              {
                # {{{2
                tug = [
                  "bookmark"
                  "move"
                  "--from"
                  "heads(::@- & bookmarks())"
                  "--to"
                  "@-"
                ];
                # }}}2
              }

              # Custom fish scripts for aliases {{{2
              (lib.lists.foldr (file: agg:
                agg
                // {
                  "${lib.removeSuffix ".fish" (builtins.baseNameOf file)}" = [
                    "util"
                    "exec"
                    "--"
                    (pkgs.writers.writeFish "${baseNameOf file}" file)
                  ];
                }) {} (lib.fileset.toList (lib.fileset.fileFilter (file: file.hasExt "fish") ./jj/aliases)))
            ]; #  }}}2
            # {{{1
            templates = {
              draft_commit_description = ''
                concat(
                  builtin_draft_commit_description,
                  "\nJJ: ignore-rest\n",
                  diff.git(),
                )
              '';
            };
            # }}}1
          };
        };
      };
    }

    (lib.mkIf (cfg.diff-editor == "meld") {
      home.packages = [pkgs.meld];
    })
  ]);
}
# vim: fdm=marker

