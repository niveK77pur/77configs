{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.taskwarrior;
in {
  options.taskwarrior = {
    enable = lib.mkEnableOption "taskwarrior";
  };

  config = lib.mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };

    home.packages = [pkgs.taskwarrior-tui];
  };
}
