{pkgs, ...}: {
  config = {
    home.packages = [
    ];

    programs.wezterm.enable = true;

    programs.fish = {
      enable = true;
      # plugins = [ "TODO" ];
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;
    };
  };
}
