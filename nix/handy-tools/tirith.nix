{
  lib,
  config,
  ...
}: let
  cfg = config.tirith;
in {
  options.tirith = {
    enable = lib.mkEnableOption "tirith";
  };

  config = lib.mkIf cfg.enable {
    programs.tirith = {
      enable = true;
    };
    programs.mcp = {
      # We want to have at least this additional server enabled
      enable =
        config.programs.opencode.enable || config.programs.claude-code.enable;
      servers.tirith = {
        command = lib.getExe config.programs.tirith.package;
        args = ["mcp-server"];
      };
    };
  };
}
