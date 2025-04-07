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
    ./new-lilypond-project.nix
    ./mrandr.nix
  ];

  options.myscripts = {
    enableAll = lib.mkEnableOption "myscripts";
  };
  config = lib.mkIf config.myscripts.enableAll {
    we.enable = lib.mkDefault true;
    ccopy.enable = lib.mkDefault true;
    cedit.enable = lib.mkDefault true;
    mount.enable = lib.mkDefault true;
    randomcase.enable = lib.mkDefault true;
    new-lilypond-project.enable = lib.mkDefault true;
    mrandr.enable = lib.mkDefault true;
  };
}
