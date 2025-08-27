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
              (toString (pkgs.writeShellScript "open-with-anything" ''
                file="$1"; shift 1
                echo "Executing: $@ \"$file\""
                $@ "$file"
              ''))
              "{file}"
              "{command}"
            ];
          }
        ];
      };
    };
  };
}
