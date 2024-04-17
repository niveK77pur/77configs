{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./wezterm.nix
    ./pistol.nix
  ];
  config = {
    programs.starship = {
      enable = true;
      # enableTransience = true;
    };
  };
}
