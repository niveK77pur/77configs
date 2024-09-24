{
  lib,
  config,
  ...
}: {
  options.latex.enable = lib.mkEnableOption "latex";
  config = lib.mkIf config.latex.enable {
    # Does not actually install texlive as it tends to be quite large
    xdg.configFile = {
      "latexindent" = {
        source = ../../config/latexindent;
        recursive = true;
      };
      "latexmk/latexmkrc".source = ../../home/.latexmkrc;
    };
  };
}
