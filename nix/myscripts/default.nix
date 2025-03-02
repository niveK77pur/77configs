{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myscripts = {
    enableAll = lib.mkEnableOption "myscripts";
    ccopy.enable = lib.mkEnableOption "ccopy";
    cedit.enable = lib.mkEnableOption "cedit";
    mount.enable = lib.mkEnableOption "mount";
    mrandr = {
      enable = lib.mkEnableOption "mrandr.sh";
      OUTPUT = lib.mkOption {
        description = "Output display name from xrandr";
        type = lib.types.str;
      };
      SCREEN = lib.mkOption {
        description = "Main display name from xrandr";
        type = lib.types.str;
      };
    };
    new-lilypond-project.enable = lib.mkEnableOption "new-lilypond-project";
    randomcase.enable = lib.mkEnableOption "randomcase";
    we.enable = lib.mkEnableOption "we";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enableAll {
      myscripts = {
        ccopy.enable = lib.mkDefault true;
        cedit.enable = lib.mkDefault true;
        mount.enable = lib.mkDefault true;
        mrandr.enable = lib.mkDefault true;
        new-lilypond-project.enable = lib.mkDefault true;
        randomcase.enable = lib.mkDefault true;
        we.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf cfg.ccopy.enable {home.packages = [(pkgs.callPackage ./ccopy.nix {})];})
    (lib.mkIf cfg.cedit.enable {home.packages = [(pkgs.callPackage ./cedit.nix {})];})
    (lib.mkIf cfg.mount.enable {home.packages = [(pkgs.callPackage ./mount.nix {})];})
    (lib.mkIf cfg.mrandr.enable {home.packages = [(pkgs.callPackage ./mrandr.nix {inherit (cfg.mrandr) OUTPUT SCREEN;})];})
    (lib.mkIf cfg.new-lilypond-project.enable {home.packages = [(pkgs.callPackage ./new-lilypond-project.nix {useGh = true;})];})
    (lib.mkIf cfg.randomcase.enable {home.packages = [(pkgs.callPackage ./randomcase.nix {})];})
    (lib.mkIf cfg.we.enable {home.packages = [(pkgs.callPackage ./we.nix {})];})
  ];
}
