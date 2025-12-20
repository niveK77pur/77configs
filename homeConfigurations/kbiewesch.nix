{git}: [
  {
    config = {
      coding.enableAll = true;
      handy-tools.enableAll = true;
      kdeconnect.enable = false;
      fish.enable = true;
      ghostty = {
        enable = true;
        package = null;
      };
      starship.enable = true;
      git = {inherit (git) userName userEmail;};
      jj = {inherit (git) userName userEmail;};
      autoraise.enable = true;
    };
  }
]
