{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.bat;
in {
  options.bat = {
    enable = lib.mkEnableOption "bat";

    enableBashIntegration = lib.hm.shell.mkBashIntegrationOption {
      inherit config;
      extraDescription = "If enabled, this will bind `ctrl-r` to open the Atuin history.";
    };

    enableFishIntegration = lib.hm.shell.mkFishIntegrationOption {
      inherit config;
      extraDescription = "If enabled, this will bind the up-arrow key to open the Atuin history.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batman
        ];
      };

      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
        batman --export-env | source
      '';

      bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
        eval "$(batman --export-env)"
      '';
    };
  };
}
