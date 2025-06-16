{
  lib,
  config,
  ...
}: let
  cfg = config.ghostty;
in {
  options.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      installVimSyntax = true;
      settings = {};
      themes = {};
    };
  };
}
