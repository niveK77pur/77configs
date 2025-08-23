{
  lib,
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
            execution = "{command} {file}";
          }
        ];
      };
    };
  };
}
