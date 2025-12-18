{
  lib,
  config,
  ...
}: let
  cfg = config.nix-your-shell;
in {
  options.nix-your-shell = {
    enable = lib.mkEnableOption "nix-your-shell";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-your-shell = {
      enable = true;
    };
  };
}
