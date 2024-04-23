{buildGoModule}:
buildGoModule {
  pname = "mount-go";
  version = "1.0.0";

  src = ../../compiled-programs/mount-go;
  vendorHash = "sha256-qeE5h/pcwUPSQ0lLj7r5u2bYsycMBdDcNwgTMY+AC/o=";

  meta = {
    description = "(Un-)mount USB devices [Go version]";
    mainProgram = "mount-go";
  };
}
