{...}: {
  config = {
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
