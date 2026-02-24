{
  config,
  lib,
  ...
}: {
  imports =
    (lib.fileset.toList (
      lib.fileset.fileFilter
      (file: (file.hasExt "nix") && (file.name != "default.nix"))
      ./.
    ))
    ++ [
      ../coding/lazygit.nix
      ../coding/ripgrep.nix
    ];

  options.handy-tools.enableAll = lib.mkEnableOption "handy-tools";

  config = lib.mkIf config.handy-tools.enableAll {
    aria2.enable = lib.mkDefault true;
    atuin.enable = lib.mkDefault true;
    bat.enable = lib.mkDefault true;
    broot.enable = lib.mkDefault true;
    comma.enable = lib.mkDefault true;
    direnv.enable = lib.mkDefault true;
    dua.enable = lib.mkDefault true;
    duf.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    fd.enable = lib.mkDefault true;
    fzf.enable = lib.mkDefault true;
    hours.enable = lib.mkDefault true;
    kdeconnect.enable = lib.mkDefault true;
    lazygit.enable = lib.mkDefault true;
    lf.enable = lib.mkDefault true;
    magic-wormhole.enable = lib.mkDefault true;
    mosh.enable = lib.mkDefault true;
    nix-your-shell.enable = lib.mkDefault true;
    parallel.enable = lib.mkDefault true;
    pay-respects.enable = lib.mkDefault true;
    pdfarranger.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
    sx.enable = lib.mkDefault true;
    taskwarrior.enable = lib.mkDefault true;
    viddy.enable = lib.mkDefault true;
    vidir.enable = lib.mkDefault true;
    yazi.enable = lib.mkDefault true;
    z-lua.enable = lib.mkDefault true;
    zellij.enable = lib.mkDefault true;
  };
}
