{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      ani-cli
    ];
  };
}
