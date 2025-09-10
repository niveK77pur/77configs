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
          cleaner = toString (pkgs.writeShellScript "cleaner.sh" ''
            # See https://github.com/gokcehan/lf/issues/1885#issuecomment-2885921225
            printf "\e_Ga=d,d=A;\e\\" >/dev/tty
          '');
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
        previewer = {
          source = pkgs.writeShellScript "preview.sh" ''
            file="$1"
            width="$2"
            heigt="$3"
            x="$4"
            y="$5"

            chafaPreview() (
              # See https://github.com/gokcehan/lf/issues/1885#issuecomment-2885921225
              # Buffer the output of chafa
              output=$(${pkgs.chafa}/bin/chafa --format kitty --animate off --polite on --size "$width"x"$height" "$@")
              printf "\e["$(($y + 1))";"$x"H" >/dev/tty # set the cursor to the correct position
              printf $output >/dev/tty # print the chafa output
              exit 1 # exit with non-zero, so that the image gets redrawn every time
            )

            case "$(file -Lb --mime-type -- "$file")" in
              image/*) chafaPreview "$file" ;;
              video/*)
                  prev=$(mktemp --suffix=.jpg)
                  trap 'rm -rf -- "$prev"' EXIT
                  ${pkgs.ffmpegthumbnailer}/bin/ffmpegthumbnailer -s0 -m -f -i "$file" -c jpeg -o "$prev"
                  chafaPreview "$prev"
                ;;
              application/pdf)
                  prev=$(mktemp --suffix=.qoi)
                  trap 'rm -rf -- "$prev"' EXIT
                  ${pkgs.imagemagick.override {ghostscriptSupport = true;}}/bin/magick "$file[0]" "$prev"
                  chafaPreview --threshold=1 --bg=white "$prev"
                ;;
              *) ${pkgs.pistol}/bin/pistol "$file" ;;
            esac
          '';
        };
      };

      programs.fish.shellInit = ''
        bind ctrl-o 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
      '';
    }
    (lib.mkIf cfg.icons {
      # TODO: Fetch from GitHub
      xdg.configFile."lf/icons".source = ../../config/lf/icons;
    })
  ]);
}
# vim: fdm=marker

