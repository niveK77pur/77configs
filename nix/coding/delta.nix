{
  lib,
  config,
  ...
}: let
  cfg = config.delta;
in {
  options.delta = {
    enable = lib.mkEnableOption "delta";
    enableJujutsuIntegration = lib.mkEnableOption "difftastic jujutsu";
  };

  config = lib.mkIf cfg.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      inherit (cfg) enableJujutsuIntegration;
      options = {
        line-numbers = true;
        color-moved = "default";
      };
    };
  };
}
