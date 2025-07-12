{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.dunst;
in {
  options.dunst = {
    enable = lib.mkEnableOption "dunst";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];
    services.dunst = {
      enable = true;
      settings = {
        global = {
          # display {{{1
          monitor = "0";
          follow = "mouse";
          # geometry = "500x0-25+25"; # TODO: Check geometry?
          indicate_hidden = true;
          shrink = false;
          transparency = 0;
          separator_height = 1;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          # frame_color = "#e68a00";
          # separator_color = "frame";
          sort = true;
          idle_threshold = 120;

          # text {{{1
          # font = "FiraCode Nerd Font Mono"; # ISSUE: Check why font is not working
          line_height = 0;
          markup = "full";
          format = ''<b>%s</b>\n%b'';
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 30;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;

          # icons {{{1
          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;
          # icon_path = "/usr/share/icons/Adwaita/16x16/status/:/usr/share/icons/Adwaita/16x16/devices/"; # TODO: needed?

          # history {{{1
          sticky_history = true;
          history_length = 20;

          # misc / advanced {{{1

          # dmenu = "/usr/bin/dmenu -p dunst:"; # TODO: Keep?
          # browser = "/usr/bin/firefox -new-tab"; # TODO: Keep?

          always_run_script = true;

          title = "Dunst";
          class = "Dunst";

          # startup_notification = false;
          # Manage dunst's desire for talking
          # Can be one of the following values:
          #  crit: Critical features. Dunst aborts
          #  warn: Only non-fatal warnings
          #  mesg: Important Messages
          #  info: all unimportant stuff
          # debug: all less than unimportant stuff
          # verbosity = "mesg";

          corner_radius = 7;
          # ignore_dbusclose = false;
          # force_xinerama = false;

          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_current";
          mouse_right_click = "close_all";
          #  }}}1
        };

        # Urgency sections {{{
        # urgency_low = {
        #   background = "#222222";
        #   foreground = "#888888";
        #   timeout = 10;
        # };
        # urgency_normal = {
        #   background = "#444444";
        #   foreground = "#ffffff";
        #   timeout = 10;
        # };
        # urgency_critical = {
        #   background = "#900000";
        #   foreground = "#ffffff";
        #   frame_color = "#ff0000";
        #   timeout = 0;
        # };
        #  }}}
      };
    };
  };
}
# vim: fdm=marker

