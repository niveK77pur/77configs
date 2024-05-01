{
  lib,
  setConfigsRecursive,
  ...
}: {
  config = {
    # Does not actually install texlive as it tends to be quite large
    xdg.configFile = lib.mkMerge [
      (setConfigsRecursive ../../config/latexindent)
      {
        "latexmk/latexmkrc".source = ../../home/.latexmkrc;
      }
    ];
  };
}
