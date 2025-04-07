{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.myscripts;
in {
  imports = [
    ./we.nix
    ./ccopy.nix
    ./cedit.nix
    ./mount.nix
    ./randomcase.nix
  ];

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
    we.enable = lib.mkDefault true;
    ccopy.enable = lib.mkDefault true;
    cedit.enable = lib.mkDefault true;
    mount.enable = lib.mkDefault true;
    randomcase.enable = lib.mkDefault true;
    home.packages =
      [
        (pkgs.callPackage ./new-lilypond-project.nix {useGh = true;})
        # (pkgs.callPackage ./mount-go.nix {})
      ]
      ++ lib.lists.optional cfg.mrandr.enable (pkgs.callPackage ./mrandr.nix {inherit (cfg.mrandr) OUTPUT SCREEN;});
  };
}
