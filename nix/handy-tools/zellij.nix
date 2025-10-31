{
  lib,
  config,
  ...
}: {
  options.zellij.enable = lib.mkEnableOption "zellij";
  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
    };
    xdg.configFile."zellij/config.kdl" = {
      source = ../../config/zellij/config.kdl;
    };
  };
}
