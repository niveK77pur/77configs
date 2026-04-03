{
  lib,
  config,
  ...
}: {
  options.rio.enable = lib.mkEnableOption "rio";
  config = lib.mkIf config.rio.enable {
    assertions = [
      {
        # See: https://rioterm.com/docs/config#navigationcurrent-working-directory
        assertion = let
          rs = config.programs.rio.settings;
        in
          ((rs ? navigation.current-working-directory) && rs.navigation.current-working-directory)
          -> !((rs ? use-fork) -> rs.use-fork);
        message = "navigation.current-working-directory=true requires use-fork=false";
      }
    ];
    programs.rio = {
      enable = true;
      settings = {
        use-fork = false;
        enable-scroll-bar = true;
        effects = {
          trail-cursor = true;
        };
        navigation = {
          current-working-directory = true;
        };
        scroll = {
          multiplier = 9.0;
          divider = 1.0;
        };
      };
    };
  };
}
# vim: fdm=marker

