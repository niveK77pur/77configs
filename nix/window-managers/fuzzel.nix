{
  # pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.fuzzel;
in {
  options.fuzzel = {
    enable = lib.mkEnableOption "fuzzel";
  };

  config = lib.mkIf cfg.enable {
    # home.packages = [
    #   pkgs.nerd-fonts.fira-code
    # ];
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          list-executables-in-path = true;
          # font = "FiraCode Nerd Font"; # FIX: Font not working
          use-bold = true;
          show-actions = true;
          terminal = "${config.wezterm.package}/bin/wezterm start";
        };
      };
    };
  };
}
