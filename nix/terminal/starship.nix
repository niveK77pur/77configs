{
  lib,
  config,
  ...
}: {
  options.starship.enable = lib.mkEnableOption "starship";
  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      # enableTransience = true;
    };

    xdg.configFile."starship.toml".source = ../../config/starship.toml;
  };
}
