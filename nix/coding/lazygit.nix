{
  pkgs,
  lib,
  config,
  helper,
  ...
}: {
  options.lazygit.enable = lib.mkEnableOption "lazygit";
  config = lib.mkIf config.lazygit.enable {
    home.packages = with pkgs; [
      commitizen
    ];

    programs.lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "C";
            command = "git cz c";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commitizen commit tool";
            output = "terminal";
          }
        ];
      };
    };
    programs.fish.functions = {
      lg = helper.makeFishAliasFunction {
        body = "lazygit $argv";
      };
    };
  };
}
