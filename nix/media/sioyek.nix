{
  lib,
  config,
  ...
}: let
  cfg = config.sioyek;
in {
  options.sioyek = {
    enable = lib.mkEnableOption "sioyek";
  };

  config = lib.mkIf cfg.enable {
    programs.sioyek = {
      enable = true;
      config = {
        should_launch_new_window = "yes";
        should_warn_about_user_key_override = "yes";
        should_draw_unrendered_pages = "yes";
        show_closest_bookmark_in_statusbar = "yes";
        show_close_portal_in_statusbar = "yes";
      };
    };
  };
}
