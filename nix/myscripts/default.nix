{pkgs, ...}: {
  config = {
    home.packages = [
      (pkgs.callPackage ./we.nix {})
      (pkgs.callPackage ./ccopy.nix {})
    ];
  };
}
