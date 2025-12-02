{
  lib,
  config,
  ...
}: let
  cfg = config.mergiraf;
in {
  options.mergiraf = {
    enable = lib.mkEnableOption "mergiraf";
  };

  config = lib.mkIf cfg.enable {
    programs.mergiraf.enable = true;
  };
}
