{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    mrandr = {
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
  config = {
    home.packages = [
      (pkgs.callPackage ./we.nix {mpv = config.programs.mpv.finalPackage;})
      (pkgs.callPackage ./ccopy.nix {})
      (pkgs.callPackage ./cedit.nix {})
      (pkgs.callPackage ./mount.nix {})
      (pkgs.callPackage ./mrandr.nix {inherit (config.mrandr) OUTPUT SCREEN;})
      (pkgs.callPackage ./randomcase.nix {})
      (pkgs.callPackage ./new-lilypond-project.nix {useGh = true;})
      # (pkgs.callPackage ./mount-go.nix {})
    ];
  };
}
