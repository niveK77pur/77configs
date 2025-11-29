{
  lib,
  config,
  ...
}: let
  cfg = config.difftastic;
in {
  options.difftastic = {
    enable = lib.mkEnableOption "difftastic";
  };

  config = lib.mkIf cfg.enable {
    programs.difftastic = {
      enable = true;
    };
    programs.jujutsu.settings = {
      ui.diff-formatter = [
        (lib.getExe config.programs.difftastic.package)
        "--color=always"
        "$left"
        "right"
      ];
    };
  };
}
