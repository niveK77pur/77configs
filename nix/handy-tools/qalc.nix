{
  lib,
  config,
  ...
}: let
  cfg = config.qalc;
in {
  options.qalc = {
    enable = lib.mkEnableOption "qalc";
    withFishBind = lib.mkEnableOption "qalc-fish-bind" // {default = true;};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.qalculate = {
        enable = true;
      };
    }
    (lib.mkIf cfg.withFishBind {
      programs.fish.interactiveShellInit = ''
        bind alt-q 'commandline -r ${lib.getExe config.programs.qalculate.package}' execute
      '';
    })
  ]);
}
