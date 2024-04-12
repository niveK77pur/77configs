{pkgs, ...}: {
  config = {
    home.packages = [
    ];

    programs.wezterm.enable = true;

    programs.fish.enable = true;

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;
    };
  };
}
