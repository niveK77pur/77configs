{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./wezterm.nix
  ];
  config = {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;
    };
  };
}
