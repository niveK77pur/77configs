{
  lib,
  pkgs,
  config,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "zellij";
  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
    };
    xdg.configFile."zellij/config.kdl" = {
      source = let
        patched = pkgs.applyPatches {
          src = ../..;
          patches = [../../config/zellij/zellij.patch];
        };
      in "${patched}/config/zellij/config.kdl";
    };
  };
}
