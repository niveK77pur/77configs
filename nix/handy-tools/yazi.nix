{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.yazi;
in {
  options.yazi = {
    enable = lib.mkEnableOption "yazi";
    withFishBind = lib.mkEnableOption "lf-fish-bind" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.withFishBind && config.lf.withFishBind);
        message = "Only yazi or lf can have fish bind enabled";
      }
    ];

    programs = {
      yazi = {
        enable = true;
        shellWrapperName = "y";
        extraPackages = [
          pkgs.exiftool
          pkgs.mediainfo
        ];
        plugins = {
          inherit (pkgs.yaziPlugins) piper;
          mediainfo = pkgs.fetchFromGitHub {
            owner = "boydaihungst";
            repo = "mediainfo.yazi";
            rev = "20ecff6dd154da4c6e28fc7f754e865fd5f9d1b3";
            hash = "sha256-br8UDDPxVe4ZfoHIURD2zzjmyUImhKak0DYwCF9r2vw=";
          };
        };
        initLua = ''
          require("session"):setup { sync_yanked = true, }
        '';
        settings = let
          previewers_preloaders = [
            # Replace magick, image, video with mediainfo
            {
              mime = "{audio,video,image}/*";
              run = "mediainfo";
            }
            {
              mime = "application/subrip";
              run = "mediainfo";
            }
          ];
        in {
          plugin.prepend_preloaders = previewers_preloaders;
          plugin.prepend_previewers = lib.mkMerge [
            previewers_preloaders
            [
              {
                url = "*.adoc";
                run = ''piper -- ${lib.getExe pkgs.asciidoctor} -b html5 -o - "$1" 2>/dev/null | ${lib.getExe pkgs.pandoc} -f html -t gfm --wrap=none | CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark -'';
              }
              {
                url = "*.md";
                run = ''piper -- CLICOLOR_FORCE=1 ${lib.getExe pkgs.glow} -w=$w -s=dark "$1"'';
              }
            ]
          ];
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = ["<A-d>"];
              run =
                if pkgs.stdenv.isDarwin
                then "noop"
                else "shell -- ${lib.getExe pkgs.dragon-drop} --all --and-exit %s";
              desc = "Drag and drop files from yazi";
            }
            {
              on = ["c" "i"];
              run = "shell -- wl-copy < %s";
              desc = "Copy file contents to clipboard (Wayland)";
            }
          ];
        };
        theme = {
          mgr = {
            symlink_target.dim = true;
            border_symbol = " ";
          };
        };
      };
      fish = {
        shellInit = lib.optionalString cfg.withFishBind ''
          bind ctrl-o 'set old_tty (stty -g); stty sane; ${config.programs.yazi.shellWrapperName}; stty $old_tty; commandline -f repaint'
        '';
      };
    };
  };
}
