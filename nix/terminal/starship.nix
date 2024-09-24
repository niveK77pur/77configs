{
  lib,
  config,
  ...
}: {
  options.starship.enable = lib.mkEnableOption "starship";
  config = {
    programs.starship = lib.mkIf config.starship.enable {
      enable = true;
      # enableTransience = true;
    };

    xdg.configFile."starship.toml".source = ../../config/starship.toml;
  };
}
