{
  lib,
  config,
  ...
}: let
  cfg = config.floorp;
in {
  options.floorp = {
    enable = lib.mkEnableOption "floorp";
  };

  config = lib.mkIf cfg.enable {
    programs.floorp = {
      enable = true;
      policies = {
        DefaultDownloadDirectory = "/tmp/floorp-downloads";
      };
    };
  };
}
