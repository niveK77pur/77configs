{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.broot;
in {
  options.broot = {
    enable = lib.mkEnableOption "broot";
  };

  config = lib.mkIf cfg.enable {
    programs.broot = {
      enable = true;
      settings = {
        icon_theme = "nerdfont";
        imports = [
          "${config.programs.broot.package.src}/resources/default-conf/verbs.hjson"
        ];
        verbs = [
          {
            invocation = "open {command}";
            external = [
              "${pkgs.writeShellScript "open-with-anything" ''
                file="$1"; shift 1
                echo "Executing: $@ \"$file\""
                $@ "$file"
              ''}"
              "{file}"
              "{command}"
            ];
          }
          {
            name = "open-code";
            key = "enter";
            execution = "$EDITOR +{line} {file}";
            apply_to = "text_file";
            working_dir = "{root}";
            leave_broot = false;
          }

          {
            key = "ctrl-j";
            internal = "line_down";
          }
          {
            key = "ctrl-k";
            internal = "line_up";
          }
          {
            key = "ctrl-l";
            internal = "panel_right";
          }
          {
            key = "ctrl-h";
            internal = "panel_left_no_open";
          }
        ];

        preview_transformers = [
          # PDF Preview {{{1
          {
            input_extensions = ["pdf"];
            output_extension = "png";
            mode = "image";
            command = [
              (lib.getExe' pkgs.mupdf-headless "mutool")
              "draw"
              "-w"
              "1000"
              "-o"
              "{output-path}"
              "{input-path}"
            ];
          }
          # Video Preview {{{1
          {
            #  {{{2
            input_extensions = [
              # Taken from: https://en.wikipedia.org/wiki/Video_file_format#List_of_video_file_formats
              "webm"
              "mkv"
              "flv"
              "flv"
              "vob"
              "ogv"
              "ogg"
              "drc"
              "gifv"
              "mng"
              "avi"
              "mts"
              "m2ts"
              "ts"
              "mov"
              "qt"
              "wmv"
              "yuv"
              "rm"
              "rmvb"
              "viv"
              "asf"
              "amv"
              "mp4"
              "m4p"
              "m4v"
              "mpg"
              "mp2"
              "mpeg"
              "mpe"
              "mpv"
              "mpg"
              "mpeg"
              "m2v"
              "m4v"
              "svi"
              "3gp"
              "3g2"
              "mxf"
              "roq"
              "nsv"
              "flv"
              "f4v"
              "f4p"
              "f4a"
              "f4b"
            ]; #  }}}2
            output_extension = "jpeg";
            mode = "image";
            command = [
              (lib.getExe pkgs.ffmpegthumbnailer)
              "-s"
              "0"
              "-m"
              "-f"
              "-c"
              "jpeg"
              "-i"
              "{input-path}"
              "-o"
              "{output-path}"
            ];
          }
          #  }}}1
        ];
      };
    };

    programs.fish.shellInit = ''
      bind alt-o 'br; commandline -f repaint'
    '';
  };
}
# vim: fdm=marker

