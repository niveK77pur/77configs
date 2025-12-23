{
  config,
  lib,
  ...
}: {
  imports = lib.fileset.toList (
    lib.fileset.fileFilter
    (file: (file.hasExt "nix") && (file.name != "default.nix"))
    ./.
  );

  options.coding.enableAll = lib.mkEnableOption "coding";

  config = lib.mkIf config.coding.enableAll {
    delta.enable = lib.mkDefault true;
    difftastic.enable = lib.mkDefault true;
    gh.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    jj.enable = lib.mkDefault true;
    latex.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    lazyjj.enable = lib.mkDefault true;
    mergiraf.enable = lib.mkDefault true;
    neovim.enable = lib.mkDefault true;
    nix-tools.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
  };
}
