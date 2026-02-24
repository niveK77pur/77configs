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
          ];
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
