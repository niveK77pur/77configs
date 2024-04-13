{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      python312Packages.pygments
      poppler_utils
    ];

    programs.pistol = {
      enable = true;
      associations = [
        {
          fpath = ".*/aur[^/]*/.*SRCINFO$";
          command = "pygmentize -O style=trac -l srcinfo %pistol-filename%";
        }
        {
          fpath = ".*/aur[^/]*/.*PKGBUILD$";
          command = "pygmentize -O style=trac -l bash %pistol-filename%";
        }
        {
          mime = "application/pdf";
          command = "pdftotext %pistol-filename% -";
        }
        {
          mime = "application/pdf";
          command = "pdfinfo %pistol-filename%";
        }
      ];
    };
  };
}
