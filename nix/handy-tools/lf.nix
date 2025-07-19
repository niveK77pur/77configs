{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.lf;
in {
  options.lf = {
    enable = lib.mkEnableOption "lf";
    icons = lib.mkEnableOption "lf" // {default = true;};
  };

  config = lib.mkIf config.lf.enable (lib.mkMerge [
    {
      programs.lf = {
        enable = true;
        settings = {
          # promptfmt = ''\033[0;1;33m%u@%h\033[0m:\033[35m%w/\033[1m%f\033[0m'';
          shellopts = "-eu";
          scrolloff = 10;
          inherit (cfg) icons;
        };
        keybindings = {
          D = "delete";
          E = "$$EDITOR $fs"; # Open selected files in $EDITOR
          "<a-f>" = ":fzf_jump";
          "<a-d>" = ":dragon";
        };
        commands = {
          # custom 'open' command {{{
          open = let
            #  {{{
            generateOpen = {
              extOpen,
              mimeOpen,
            }: let
              toCaseList = attr: (lib.concatLines (
                # Need to allow 'xx NAME' to preserve/allow ordering in attrset
                lib.mapAttrsToList
                (name: value: "    ${
                  # Remove 'xx ', only needed internally for ordering
                  lib.last (builtins.split " " name)
                }) ${value};;")
                (lib.mapAttrs' (name: value: let
                  i = builtins.tryEval (lib.toIntBase10 (builtins.head (builtins.split " " name)));
                in
                  # Prefix '00 ' if no 'xx ' was given, to make ordering work properly
                  lib.nameValuePair
                  (
                    if i.success
                    then name
                    else "00 " + name
                  )
                  value)
                attr)
              ));
            in
              lib.concatLines [
                "\${{"
                # based on file extension (string after last '.')
                "  case \${f##*.} in"
                (toCaseList extOpen)
                "  esac"
                # based on mime type
                "  case $(file -Lb --mime-type $f) in"
                (toCaseList mimeOpen)
                "  esac"
                "}}"
              ]; #  }}}
          in
            generateOpen {
              extOpen = {
                "ytlink|ylink" = ''firefox "$(head -n1 $f)" & exit'';
                "tlink" = ''firefox "$(head -n1 $f)" & exit'';
                "vlink" = ''vlc --quiet "$(head -n1 $f)" &> /dev/null & exit'';
                # "wlink" = ''chromium --app="$(head -n1 $f)" &> /dev/null & exit'';
                "wlink" = ''firefox --new-window "$(head -n1 $f)" & exit'';
                "link" = ''firefox "$(head -n1 $f)" & exit'';
                "md" = ''typora $f & exit'';
                "ps" = ''zathura $f & exit'';
                "flb" = ''flowblade $f & exit'';
                "blend*" = ''blender $f & exit'';
                "pcapng" = ''wireshark $f & exit'';
                "ipynb" = ''jupyter-notebook $f'';
                "docx|pptx|xlsx" = ''onlyoffice-desktopeditors & exit'';
              };

              mimeOpen = {
                "text/*" = ''$EDITOR $fx'';
                "application/pdf" = ''zathura $fx &'';
                "01 image/svg*" = ''inkscape $f &'';
                "02 image/*" = ''feh -Z --scale-down $f &'';
                "video/*" = ''mpv $f & '';
                "99 *" = ''for f in $fx; do setsid $OPENER $f > /dev/null 1> /dev/null & done'';
              };
            }; #  }}}

          dragon =
            if pkgs.stdenv.isDarwin
            then ":echoerr 'dragon-drop' not available for darwin"
            else "&${pkgs.dragon-drop}/bin/dragon-drop --all --and-exit $fx";

          # See: https://github.com/gokcehan/lf/wiki/Integrations#fzf
          fzf_jump = ''
            ''${{
              res="$(${pkgs.fd}/bin/fd | ${pkgs.fzf}/bin/fzf --reverse --header="Jump to location")"
              if [ -n "$res" ]; then
                  if [ -d "$res" ]; then
                      cmd="cd"
                  else
                      cmd="select"
                  fi
                  res="$(printf '%s' "$res" | sed 's/\\/\\\\/g;s/"/\\"/g')"
                  lf -remote "send $id $cmd \"$res\""
              fi
            }}'';
        };
        previewer = {};
      };
    }
    (lib.mkIf cfg.icons {
      # TODO: Fetch from GitHub
      xdg.configFile."lf/icons".source = ../../config/lf/icons;
    })
  ]);
}
# vim: fdm=marker

