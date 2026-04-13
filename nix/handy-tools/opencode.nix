{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.opencode;
  jujutsu-skill = pkgs.fetchFromGitHub {
    owner = "danverbraganza";
    repo = "jujutsu-skill";
    rev = "efcc70090b14e4504d8f8523dd43d6a6605b9a1e";
    hash = "sha256-rDL7M8ukN6vnWF2/G5x7fexsV/1u4M/TVhbrKzM835w=";
  };
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
  commands = mkPerms {
    allow = [
      "curl *"
      "find *"
      "git diff *"
      "git log *"
      "git show *"
      "git status *"
      "go mod tidy"
      "go build *"
      "grep *"
      "rg *"
      "head *"
      "jj show *"
      "jj diff *"
      "jj log *"
      "ls *"
      "fd *"
      "find *"
      "tail *"
      "just lint *"
      "just typecheck *"
    ];
  };
in {
  options.opencode = {
    enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      context = ../../config/opencode/AGENTS.md;
      skills = {
        jujutsu = "${jujutsu-skill}/jujutsu";
      };
      settings = {
        permission = mkPerms {
          ask = ["*"];
          allow = [
            "glob"
            "grep"
            "list"
            "lsp"
            "read"
            "skill"
            "task"
            "todoread"
            "todowrite"
            "webfetch"
            "websearch"
          ];
          granular = {
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
        provider = {
          amazon-bedrock.options = {
            region = "eu-central-1";
          };
          vllm = {
            npm = "@ai-sdk/openai-compatible";
            name = "vLLM (kair)";
            options = {
              # Accessible over tailscale
              baseURL = "http://kair:8000/v1";
            };
            models = {
              "qwen3.5-27b" = {
                name = "Qwen3.5-27B";
                options = {
                  max_tokens = 32768;
                };
              };
            };
          };
        };
      };
    };
  };
}
