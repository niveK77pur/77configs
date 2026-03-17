{
  lib,
  config,
  ...
}: let
  cfg = config.claude;
in {
  options.claude = {
    enable = lib.mkEnableOption "claude";
  };

  config = lib.mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      inherit (config.programs.opencode) skills;
    };
  };
}
