{pkgs, ...}: {
  imports = [
    ./we.nix
  ];
  config = {
    home.packages = [
      (pkgs.callPackage ./ccopy.nix {})
    ];
  };
}
