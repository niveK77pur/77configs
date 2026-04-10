{
  lib,
  pkgs,
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
      package = config.lib.nixGL.wrap pkgs.rio;
      enable = true;
      settings = {
        use-fork = false;
        enable-scroll-bar = true;
        effects = {
          trail-cursor = true;
        };
        navigation = {
          current-working-directory = true;
          mode = "Tab";
        };
        scroll = {
          multiplier = 9.0;
          divider = 1.0;
        };
        bindings.keys = lib.flatten [
          # remap tab selection
          (map (i: let
            istr = toString i;
          in [
            {
              # unmap the default
              key = istr;
              "with" = "control | shift";
              action = "ReceiveChar";
            }
            {
              key = istr;
              "with" = "alt";
              action =
                if i != 9
                then "SelectTab(${toString (i - 1)})"
                else "SelectLastTab";
            }
          ]) (lib.range 1 9))

          [
            # remap to make default mappings work on swiss french layout
            {
              key = "1";
              "with" = "control | shift";
              action = "IncreaseFontSize";
            }
            {
              key = "]";
              "with" = "control";
              action = "SelectNextSplit";
            }
            {
              key = "[";
              "with" = "control";
              action = "SelectPrevSplit";
            }
          ]
        ];
      };
    };
  };
}
# vim: fdm=marker

