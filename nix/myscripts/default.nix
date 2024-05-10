{
  pkgs,
  config,
  ...
}: {
  config = {
    home.packages = [
      (pkgs.callPackage ./we.nix {mpv = config.programs.mpv.finalPackage;})
      (pkgs.callPackage ./ccopy.nix {})
      (pkgs.callPackage ./cedit.nix {})
      (pkgs.callPackage ./mount.nix {})
      (pkgs.callPackage ./randomcase.nix {})
      (pkgs.callPackage ./new-lilypond-project.nix {useGh = true;})
      # (pkgs.callPackage ./mount-go.nix {})
    ];
  };
}
