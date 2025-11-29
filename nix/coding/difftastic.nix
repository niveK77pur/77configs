{
  lib,
  config,
  ...
}: let
  cfg = config.difftastic;
in {
  options.difftastic = {
    enable = lib.mkEnableOption "difftastic";
    enableJujutsuIntegration = lib.mkEnableOption "difftastic jujutsu";
  };

  config = lib.mkIf cfg.enable {
    programs.difftastic = {
      enable = true;
    };
    programs.jujutsu.settings = lib.mkIf cfg.enableJujutsuIntegration {
      ui.diff-formatter = [
        (lib.getExe config.programs.difftastic.package)
        "--color=always"
        "--sort-paths"
        "--syntax-highlight=off"
        "$left"
        "right"
      ];
    };
  };
}
