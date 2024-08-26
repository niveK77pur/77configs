{
  pkgs,
  lib,
  config,
  ...
}: {
  options.lazygit.enable = lib.mkEnableOption "lazygit" // {default = true;};
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
            subprocess = true;
          }
        ];
      };
    };
  };
}
