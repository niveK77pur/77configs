{
  pkgs,
  lib,
  config,
  ...
}: {
  options.pistol.enable = lib.mkEnableOption "pistol" // {default = true;};
  config = lib.mkIf config.pistol.enable {
    programs.pistol = {
      enable = true;
      associations = let
        pygmentize = "${pkgs.python312Packages.pygments}/bin/pygmentize";
        pdftotext = "${pkgs.poppler_utils}/bin/pdftotext";
        pdfinfo = "${pkgs.poppler_utils}/bin/pdfinfo";
      in [
        {
          fpath = ".*/aur[^/]*/.*SRCINFO$";
          command = "${pygmentize} -O style=trac -l srcinfo %pistol-filename%";
        }
        {
          fpath = ".*/aur[^/]*/.*PKGBUILD$";
          command = "${pygmentize} -O style=trac -l bash %pistol-filename%";
        }
        {
          mime = "application/pdf";
          command = "${pdftotext} %pistol-filename% -";
        }
        {
          mime = "application/pdf";
          command = "${pdfinfo} %pistol-filename%";
        }
      ];
    };
  };
}
