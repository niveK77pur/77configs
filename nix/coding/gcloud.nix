{
  lib,
  config,
  pkgs,
  helper,
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

          glist = helper.makeFishAliasFunction {
            body = "${gcloud} compute instances list $argv";
          };
        }

        (lib.optionalAttrs config.programs.ghostty.enable {
          gghostty = let
            infocmp = "${pkgs.ncurses}/bin/infocmp";
          in {
            body = "${infocmp} -x xterm-ghostty | ${gcloud} compute ssh $host -- tic -x -";
            argumentNames = "host";
            description = "Easily copy ghostty terminfo to gcloud machine";
          };
        })
      ];
  };
}
