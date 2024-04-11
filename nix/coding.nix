{
  pkgs,
  alejandra,
  system,
  ...
}: {
  config = {
    home.packages = [
      alejandra.defaultPackage.${system}
    ];
  };
}
