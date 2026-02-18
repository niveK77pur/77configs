{
  lib,
  config,
  ...
}: let
  cfg = config.opencode;
  mkPerms = {
    allow ? [],
    ask ? [],
    deny ? [],
    granular ? {},
  }:
    lib.mergeAttrsList (lib.flatten [
      (map (key: {${key} = "allow";}) allow)
      (map (key: {${key} = "ask";}) ask)
      (map (key: {${key} = "deny";}) deny)
      granular
    ]);
in {
  options.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        permission = mkPerms {
          ask = ["*"];
          allow = [
            "glob"
            "grep"
            "list"
            "read"
            "todoread"
            "todowrite"
          ];
          granular = let
            commands = mkPerms {
              allow = [
                "find *"
                "grep *"
                "ls *"
              ];
            };
          in {
            fish = commands;
            bash = commands;
          };
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
