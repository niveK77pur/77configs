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
        permission = {
          "*" = "ask";
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
        ];
      };
    };
  };
}
