{
  pkgs,
  lib,
  config,
  ...
}: {
  options.rio.enable = lib.mkEnableOption "rio";
  config = lib.mkIf config.rio.enable {
    home.packages = [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.victor-mono
    ];
    programs.rio = {
      enable = true;
      settings = {
        # fonts = {
        #   family = "FiraCode Nerd Font";
        #   italic = {
        #     family = "Victor Mono NF";
        #   };
        # };
        use-fork = true;
      };
    };
  };
}
# vim: fdm=marker

