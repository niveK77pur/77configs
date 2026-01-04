{
  pkgs,
  lib,
  git,
  stylix-base16Scheme,
}: [
  {
    config = {
      categories.enableAll = true;
      mpv.withAnime4k = true;
      wezterm.overrides = {
        window_background_opacity = 0.97;
        font_size = 11.1;
      };
      git = {inherit (git) userName userEmail;};
      jj = {
        inherit (git) userName userEmail;
      };
      mrandr = {
        SCREEN = "eDP-2";
        OUTPUT = "DP-1";
      };
      swww.service = {
        enable = true;
        imagesDir = "/home/kevin/Pictures/Wallpaper";
      };
      sx.base16Scheme = stylix-base16Scheme;
      firefox.withPipewireScreenaudio = true;
      hyprland = {
        enable = true;
        monitor = [
          {
            name = "eDP-1";
            scale = 1.6;
          }
          {
            name = "desc:Sony SONY TV  *00 0x01010101";
            # resolution = "1920x1080@60";
            scale = 2;
            extraArgs = {
              vrr = 3;
            };
          }
        ];
      };
    };
  }
  {
    stylix.targets.mangohud.fonts.override.sizes.applications = lib.mkForce 30;
    home.packages = [pkgs.video2x];
  }
]
