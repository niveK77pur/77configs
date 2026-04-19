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
      delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };
      programs = {
        fish = {
          shellInit = ''
            bind alt-j '${lib.getExe config.programs.jjui.package}'
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
                # {{{2
                showd = [
                  "show"
                  "--tool"
                  "difft"
                ];
                # }}}2
              }

              # Custom fish scripts for aliases {{{2
              (lib.lists.foldr (file: agg:
                agg
                // {
                  "${lib.removeSuffix ".fish" (baseNameOf file)}" = [
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
        jjui = {
          enable = true;
          settings = {
            # {{{1
            preview = lib.mkMerge [
              (lib.mkIf config.programs.delta.enable {
                revision_command = [
                  "--config"
                  "ui.diff-formatter=delta"
                  "show"
                  "--color"
                  "always"
                  "-r"
                  "$change_id"
                ];
              })
              (lib.mkIf config.programs.difftastic.enable {
                file_command = [
                  "--config"
                  "ui.diff-formatter=difft"
                  "diff"
                  "--color"
                  "always"
                  "-r"
                  "$change_id"
                  "$file"
                ];
              })
            ];
            # {{{1
            bindings = [
              {
                action = "diff-with";
                seq = [
                  "w"
                  "d"
                ];
                scope = "revisions";
              }
              {
                action = "diff-with";
                seq = [
                  "w"
                  "d"
                ];
                scope = "revisions.details";
              }
            ];
            # {{{1
            actions = [
              {
                name = "diff-with";
                lua = ''
                  local change = context.change_id()
                  if not change or change == "" then
                    flash({ text = "No change selected", error = true })
                    return
                  end

                  local file = context.file()
                  local tool = choose({
                    title = "Diff with",
                    options = {
                      "default",
                      "difft",
                      "delta",
                      ":git",
                      ":color-words",
                      ":summary",
                      ":stat",
                      ":types",
                      ":name-only",
                    },
                    ordered = true,
                  })
                  if not tool then
                    return
                  end

                  local args
                  if file and file ~= "" then
                    args = { "diff", "-r", change }
                  else
                    args = { "show", "-r", change }
                  end

                  if tool ~= "default" then
                    table.insert(args, "--tool")
                    table.insert(args, tool)
                  end

                  if file and file ~= "" then
                    table.insert(args, file)
                  end

                  local out, err = jj(args)
                  if err then
                    flash({ text = err, error = true })
                    return
                  end

                  jjui.diff.show(out)
                '';
              }
            ];
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

