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
    programs.fish.functions = let
      gcloud = "${pkgs.google-cloud-sdk}/bin/gcloud";
    in
      lib.mergeAttrsList [
        {
          gssh = {
            body = "${gcloud} compute ssh $host -- -A";
            argumentNames = "host";
            wraps = gcloud;
            description = "Easily ssh into gcloud machines";
          };
        }
      ];
  };
}
