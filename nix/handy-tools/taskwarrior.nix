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
    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      config = {} // cfg.extraConfig;
    };

    home.packages = [pkgs.taskwarrior-tui];
  };
}
