{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.ashell;
in {
  options.ashell = {
    enable = lib.mkEnableOption "ashell";
    package = lib.mkOption {
      type = lib.types.package;
      default =
        if config.home.withNixGL.enable
        then
          pkgs.writeShellScriptBin "ashell" ''
            ${config.home.withNixGL.command} ${pkgs.ashell}/bin/ashell
          ''
        else pkgs.ashell;
      description = "Package to use; wrap with nixGL if enabled";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    fuzzel.enable = true;
    wezterm.enable = true;
    xdg.configFile."ashell.yml".text = builtins.toJSON {
      appLauncherCmd = "fuzzel";
      clipboardCmd = "${config.wezterm.package}/bin/wezterm start --class clipse -e clipse";
      modules = {
        left = [
          "AppLauncher"
          "Clipboard"
          "Workspaces"
        ];
        center = [
          # "WindowTitle"
          "Clock"
        ];
        right = [
          "Tray"
          [
            "Privacy"
            "Settings"
            "SystemInfo"
          ]
        ];
      };
    };
  };
}
