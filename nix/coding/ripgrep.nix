{
  lib,
  config,
  ...
}: {
  options.ripgrep.enable = lib.mkEnableOption "ripgrep";
  config = lib.mkIf config.ripgrep.enable {
    programs.ripgrep.enable = true;
  };
}
