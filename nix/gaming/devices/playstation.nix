{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      bluez # use PS controller via bluetooth
    ];
  };
}
