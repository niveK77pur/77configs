{git}: [
  {
    config = {
      coding.enableAll = true;
      handy-tools.enableAll = true;
      system.enableAll = true;
      terminal.enableAll = true;
      latex.enable = true;
      git = {inherit (git) userName userEmail;};
      jj = {inherit (git) userName userEmail;};
    };
  }
]
