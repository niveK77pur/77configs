{
  lib,
  config,
  ...
}: {
  options.mangohud.enable = lib.mkEnableOption "mangohud";
  config = lib.mkIf config.mangohud.enable {
    stylix.targets.mangohud = {
      fonts.override.sizes.applications = 24;
      opacity.override.popups = 0.3;
    };

    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
      settings = {
        fps_limit = "60,90,120,0";
        fps_limit_method = "early";
        no_display = true;

        # visual
        time = true;
        time_no_label = true;
        version = true;

        gpu_stats = true;
        gpu_temp = true;
        gpu_load_change = true;
        gpu_name = true;

        cpu_stats = true;
        cpu_temp = true;
        cpu_load_change = true;

        vram = true;
        ram = true;
        swap = true;

        device_battery = "gamepad,mouse";

        fps = true;
        frametime = true;
        show_fps_limit = true;

        vulkan_driver = true;
        wine = true;
        exec_name = true;
        arch = true;
        engine_version = true;

        frame_timing = true;
        gamemode = true;
        mangoapp_steam = true;
        resolution = true;

        position = "top-right";
        round_corners = 10.0;

        # interaction
        toggle_hud = "Shift_R+F1";
        toggle_fps_limit = "Shift_R+F2";
        toggle_hud_position = "Shift_R+F3";
        reload_cfg = "Shift_R+F4";

        # log
        output_folder = "/tmp/mangologs";
        permit_upload = 0;
      };
    };
  };
}
