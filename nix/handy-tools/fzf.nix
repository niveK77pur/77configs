{
  lib,
  config,
  ...
}: {
  options.fzf.enable = lib.mkEnableOption "fzf";
  config = lib.mkIf config.fzf.enable {
    programs.fzf = {
      enable = true;
    };
  };
}
