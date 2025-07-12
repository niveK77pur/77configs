{
  lib,
  config,
  ...
}: {
  options.zathura.enable = lib.mkEnableOption "zathura";
  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
      options = lib.mergeAttrsList [
        {
          "zoom-step" = 20;
          "selection-clipboard" = "clipboard";
          "window-title-home-tilde" = true;
          "statusbar-basename" = true;

          # Recoloring
          "recolor-reverse-video" = true;
          "recolor-keephue" = true;
          "recolor" = true;
        }

        (lib.optionalAttrs (!config.sx.enable) {
          "recolor-darkcolor" = "#ced5e5";
          "recolor-lightcolor" = "#201f30";
          # "recolor-darkcolor" = "#d8caac";
          # "recolor-lightcolor" = "#323d43";
          # "default-bg" = "#2c343a";
          # "default-bg" = "#262E33";
          # "default-bg" = "#222A2E";
        })
      ];
      mappings = {
        "[normal] <Space>" = "navigate next";
        "[normal] <BackSpace>" = "navigate previous";
        "[fullscreen] <Space>" = "navigate next";
        "[fullscreen] <BackSpace>" = "navigate previous";

        # Does not seem to work
        "[normal] <S-b>" = "mark_add m";
        "[normal] b" = "mark_evaluate m";
      };
      extraConfig = lib.concatLines [
        "unmap [normal] <C-p>"
      ];
    };
  };
}
