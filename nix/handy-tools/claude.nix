{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.claude;
in {
  options.claude = {
    enable = lib.mkEnableOption "claude";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.claude-code];
  };
}
