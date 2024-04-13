{pkgs, ...}: {
  imports = [
    ./fish.nix
  ];
  config = {
    programs.wezterm.enable = true;

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;
    };
  };
}
