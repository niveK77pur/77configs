{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.gcloud;
in {
  options.gcloud = {
    enable = lib.mkEnableOption "gcloud";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.google-cloud-sdk];
  };
}
