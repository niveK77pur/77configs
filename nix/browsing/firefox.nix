{
  lib,
  config,
  ...
}: {
  options.firefox.enable = lib.mkEnableOption "firefox" // {default = true;};

  config = lib.mkIf config.firefox.enable {
    programs.firefox.enable = true;
  };
}
