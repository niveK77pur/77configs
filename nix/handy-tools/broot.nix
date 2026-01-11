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

