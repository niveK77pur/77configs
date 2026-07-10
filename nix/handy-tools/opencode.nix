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
    rev = "b0668317ec8b375ea3d5815d3f029f4104443a0b";
    hash = "sha256-EcQWhnk4KQBQncemlQQTn2XXvUXVdYKkB2OJSpGQ4AI=";
  };
  ai-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "694fa30311e02c2639942308513555e61ee84a6f";
    hash = "sha256-NGRKdnHSBKoR48zGotmJ3zGXnQ58ogudv8T4Va/2DSY=";
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
        handoff = "${ai-skills}/skills/productivity/handoff";
        write-a-skill = "${ai-skills}/skills/productivity/write-a-skill";
        grill-with-docs = "${ai-skills}/skills/engineering/grill-with-docs";
        no-slop-prose = ../../config/opencode/skills/no-slop-prose;
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
            name = "vLLM (braddl)";
            options = {
              # ssh forward port: ssh -L 8000:localhost:8000 braddl
              baseURL = "http://localhost:8000/v1";
            };
            models = {
              "qwen3.5-9b-lb" = {
                name = "Luxembourg LLM Charel";
                options = {
                  # 8192 is the model's full context; cap output well below
                  # it so the prompt has room.
                  max_tokens = 4096;
                };
              };
            };
          };
        };
      };
    };
  };
}
