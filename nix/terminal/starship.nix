{
  lib,
  config,
  ...
}: {
  options.starship.enable = lib.mkEnableOption "starship";
  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      # enableTransience = true;
      settings = {
        add_newline = false;
        #  {{{
        format = lib.concatStrings [
          "┏ "
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$singularity"
          "$kubernetes"
          "$directory"
          "$vcsh"
          "$fossil_branch"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$hg_branch"
          "$pijul_channel"
          "$docker_context"
          "$package"
          "$c"
          "$cmake"
          "$cobol"
          "$daml"
          "$dart"
          "$deno"
          "$dotnet"
          "$elixir"
          "$elm"
          "$erlang"
          "$fennel"
          "$golang"
          "$guix_shell"
          "$haskell"
          "$haxe"
          "$helm"
          "$java"
          "$julia"
          "$kotlin"
          "$gradle"
          "$lua"
          "$nim"
          "$nodejs"
          "$ocaml"
          "$opa"
          "$perl"
          "$php"
          "$pulumi"
          "$purescript"
          "$python"
          "$raku"
          "$rlang"
          "$red"
          "$ruby"
          "$rust"
          "$scala"
          "$solidity"
          "$swift"
          "$terraform"
          "$vlang"
          "$vagrant"
          "$zig"
          "$buf"
          "$nix_shell"
          "$conda"
          "$meson"
          "$spack"
          "$memory_usage"
          "$aws"
          "$gcloud"
          "$openstack"
          "$azure"
          "$env_var"
          "$crystal"
          "$custom"
          "$sudo"
          "$line_break"
          "┗ "
          "$jobs"
          "$battery"
          "$time"
          "$os"
          "$container"
          "$shell"
          "$character"
        ]; #  }}}
        right_format = lib.concatStrings [
          "$cmd_duration"
          "$status"
        ];

        aws = {
          symbol = "  ";
        };
        battery = {
          charging_symbol = "";
          disabled = true;
          discharging_symbol = "";
          display = [
            {
              disabled = false;
              style = "bold red";
              threshold = 15;
            }
            {
              disabled = false;
              style = "bold yellow";
              threshold = 50;
            }
            {
              disabled = false;
              style = "bold green";
              threshold = 80;
            }
          ];
          full_symbol = "";
        };
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        cmd_duration = {
          format = "[󰔛 $duration]($style) ";
        };
        conda = {
          symbol = " ";
        };
        dart = {
          symbol = " ";
        };
        directory = {
          before_repo_root_style = "dimmed cyan";
          fish_style_pwd_dir_length = 1;
          read_only = " 󰌾";
          repo_root_style = "bold green";
        };
        docker_context = {
          symbol = " ";
        };
        elixir = {
          symbol = " ";
        };
        elm = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        git_status = {
          ahead = "⇡\${count}";
          behind = "⇣\${count}";
          deleted = "x";
          diverged = "󱒓⇡\${ahead_count}⇣\${behind_count}";
        };
        golang = {
          symbol = " ";
        };
        guix_shell = {
          symbol = " ";
        };
        haskell = {
          symbol = " ";
        };
        haxe = {
          symbol = "⌘ ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        java = {
          symbol = " ";
        };
        julia = {
          symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        os = {
          symbols = {
            Alpaquita = " ";
            Alpine = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            Artix = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = "󰛓 ";
            Gentoo = " ";
            HardenedBSD = "󰞌 ";
            Illumos = "󰈸 ";
            Linux = " ";
            Mabox = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            OpenBSD = "󰈺 ";
            OracleLinux = "󰌷 ";
            Pop = " ";
            Raspbian = " ";
            RedHatEnterprise = " ";
            Redhat = " ";
            Redox = "󰀘 ";
            SUSE = " ";
            Solus = "󰠳 ";
            Ubuntu = " ";
            Unknown = " ";
            Windows = "󰍲 ";
            openSUSE = " ";
          };
        };
        package = {
          symbol = "󰏗 ";
        };
        php = {
          symbol = " ";
        };
        pijul_channel = {
          symbol = "🪺 ";
        };
        python = {
          symbol = " ";
        };
        rlang = {
          symbol = "󰟔 ";
        };
        ruby = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        scala = {
          symbol = " ";
        };
        shell = {
          disabled = false;
          unknown_indicator = "sh?";
        };
        shlvl = {
          disabled = false;
          symbol = "󰇭 ";
        };
        spack = {
          symbol = "🅢 ";
        };
        status = {
          disabled = false;
          format = "[$symbol$status]($style)";
          symbol = " ";
        };
        sudo = {
          disabled = false;
          format = "[$symbol]($style)";
          symbol = "󰌋 ";
        };
        time = {
          disabled = false;
          format = "[$time]($style) ";
        };
      };
    };
  };
}
# vim: fdm=marker

