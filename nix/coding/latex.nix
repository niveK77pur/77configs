{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.latex;
in {
  options.latex = {
    enable = lib.mkEnableOption "latex";
    latexindent = {
      enable = lib.mkEnableOption "latexindent" // {default = cfg.enable;};
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.latex.enable {
      # Does not actually install texlive as it tends to be quite large
      xdg.configFile = {
        "latexmk/latexmkrc".source = ../../home/.latexmkrc;
      };
    })

    (lib.mkIf cfg.latexindent.enable (let
      mysettings = builtins.toFile "mysettings.yaml" (lib.generators.toYAML {} {
        defaultIndent = "  ";

        indentAfterHeadings = {
          part.indentAfterThisHeading = 1;
          chapter.indentAfterThisHeading = 1;
          section.indentAfterThisHeading = 1;
          subsection.indentAfterThisHeading = 1;
          "subsection*".indentAfterThisHeading = 1;
          subsubsection.indentAfterThisHeading = 1;
          paragraph.indentAfterThisHeading = 1;
          subparagraph.indentAfterThisHeading = 1;
        };

        onlyOneBackUp = 1;
        maxNumberOfBackups = 3;

        verbatimCommands = {
          nameAsRegex = null;
          name = ''’\w+inline’'';
          lookForThis = 1;
        };

        modifyLineBreaks = {
          condenseMultipleBlankLinesInto = 2;
          textWrapOptions = {
            columns = 70;
            blocksFollow.headings = 0;
          };
          environments = {
            BeginStartsOnOwnLine = 2;
            BodyStartsOnOwnLine = 0;
            EndStartsOnOwnLine = 0;
            EndFinishesWithLineBreak = 0;
            tabular.EndStartsOnOwnLine = 0;
            tblr.EndStartsOnOwnLine = 0;
          };
        };

        noIndentBlock.mintinline = {
          begin = ''(?<!\\)\\mintinline\{'';
          body = ''[^}]*?\}\{[^}]*?'';
          end = ''\}'';
        };
      });
    in {
      # Seems like source for `texlivePackages.latexindent` is no longer
      # reachable
      home.packages = [pkgs.perlPackages.LatexIndent];

      xdg.configFile."latexindent/indentconfig.yaml".text = lib.generators.toYAML {} {
        paths = [
          mysettings
        ];
      };
    }))
  ];
}
