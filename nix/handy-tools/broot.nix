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
      };
    };

    programs.fish.shellInit = ''
      bind alt-o 'br; commandline -f repaint'
    '';
  };
}
