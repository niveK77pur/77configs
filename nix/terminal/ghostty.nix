{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ghostty;
in {
  options.ghostty = {
    enable = lib.mkEnableOption "ghostty";
    package = lib.mkOption {
      type = lib.types.package;
      default =
        if config.home.withNixGL.enable
        then
          pkgs.writeShellScriptBin "ghostty" ''
            ${config.home.withNixGL.command} ${pkgs.ghostty}/bin/ghostty
          ''
        else pkgs.ghostty;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      inherit (cfg) package;
      enable = true;
      installBatSyntax = false; # stuck on a previous generation
      settings = {
        theme = "duskfox";
      };
      themes = {};
    };
  };
}
