{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myscripts;
in {
  options.myscripts = {
    enableAll = lib.mkEnableOption "myscripts";
    mrandr = {
      enable = lib.mkEnableOption "mrandr.sh" // {default = true;};
      OUTPUT = lib.mkOption {
        description = "Output display name from xrandr";
        type = lib.types.str;
      };
      SCREEN = lib.mkOption {
        description = "Main display name from xrandr";
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf config.myscripts.enableAll {
    home.packages =
      [
        (
          pkgs.callPackage ./we.nix (
            {mpv = config.programs.mpv.finalPackage;}
            // (lib.attrsets.optionalAttrs config.mpv.withAnime4k {inherit (config.mpv) anime4kProfileName;})
          )
        )
        (pkgs.callPackage ./ccopy.nix {})
        (pkgs.callPackage ./cedit.nix {})
        (pkgs.callPackage ./mount.nix {})
        (pkgs.callPackage ./randomcase.nix {})
        (pkgs.callPackage ./new-lilypond-project.nix {useGh = true;})
        # (pkgs.callPackage ./mount-go.nix {})
      ]
      ++ lib.lists.optional cfg.mrandr.enable (pkgs.callPackage ./mrandr.nix {inherit (cfg.mrandr) OUTPUT SCREEN;});
  };
}
