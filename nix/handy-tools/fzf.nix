{
  lib,
  config,
  ...
}: {
  options.fzf.enable = lib.mkEnableOption "fzf" // {default = true;};
  config = lib.mkIf config.fzf.enable {
    programs.fzf = {
      enable = true;
    };
  };
}
