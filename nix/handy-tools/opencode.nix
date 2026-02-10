{
  lib,
  config,
  ...
}: let
  cfg = config.opencode;
in {
  options.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        permission = let
          commands = {
            "find *" = "allow";
            "grep *" = "allow";
            "ls *" = "allow";
          };
        in {
          "*" = "ask";

          glob = "allow";
          grep = "allow";
          list = "allow";
          read = "allow";
          todoread = "allow";
          todowrite = "allow";

          fish = commands;
          bash = commands;
        };
        formatter = {
          nixfmt = {
            disabled = true;
          };
          alejandra = {
            command = ["alejandra" "$FILE"];
            extensions = [".nix"];
          };
        };
        plugin = [
          "@franlol/opencode-md-table-formatter@0.0.3"
          "opencode-gemini-auth@latest"
        ];
      };
    };
  };
}
