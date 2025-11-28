{
  lib,
  config,
  ...
}: let
  cfg = config.delta;
in {
  options.delta = {
    enable = lib.mkEnableOption "delta";
  };

  config = lib.mkIf cfg.enable {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options = {
        line-numbers = true;
        color-moved = "default";
      };
    };
  };
}
