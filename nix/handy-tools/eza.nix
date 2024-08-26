{
  lib,
  config,
  ...
}: {
  options.eza.enable = lib.mkEnableOption "eza" // {default = true;};
  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = true;
    };
  };
}
