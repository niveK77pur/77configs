{
  lib,
  config,
  ...
}: {
  options.ripgrep.enable = lib.mkEnableOption "ripgrep" // {default = true;};
  config = lib.mkIf config.ripgrep.enable {
    programs.ripgrep.enable = true;
  };
}
