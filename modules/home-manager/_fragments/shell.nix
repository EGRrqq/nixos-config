{ pkgs, config, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config = {
        show_banner: false
        edit_mode: vi
        menus: [
          {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: { layout: columnar, columns: 4, col_width: 20, col_padding: 2 }
            style: { text: green, selected_text: green_reverse, description_text: blue_bold }
          }
          {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: { layout: list, page_size: 10 }
            style: { text: green, selected_text: green_reverse, description_text: blue_bold }
          }
          {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
              layout: description, columns: 4, col_width: 20, col_padding: 2
              selection_rows: 4, description_rows: 10
            }
            style: { text: green, selected_text: green_reverse, description_text: blue_bold }
          }
        ]
        completions: {
          case_sensitive: false, quick: true, partial: true
          algorithm: "fuzzy", use_ls_colors: true
          external: { enable: true, max_results: 100 }
        }
      }
      $env.LS_COLORS = (vivid generate ayu | str trim)
      $env.PATH = ($env.PATH |
        prepend ($env.HOME)/.apps |
        prepend $env.HOME |
        prepend /.nix-profile/bin |
        append /usr/bin/env
      )

      def --env mkcd [path: string] {
        try {
          ^mkdir -p $path
          cd $path
        } catch {
          error make {msg: $"Failed to create or cd into directory: ($path)"}
        }
      }

      def --env tmpcd [dirname?: string] {
        try {
          if ($dirname != null) {
            mkcd $"/tmp/($dirname)"
          } else {
            let tmp = (^mktemp -d)
            cd $tmp
          }
        } catch {
          error make {msg: "Failed to create temporary directory"}
        }
      }
    '';
    shellAliases = {
      vi = "hx";
      nano = "hx";
      nn = "sudo nixos-rebuild switch --flake ~/.config/nixos/#blob";
      nd = "sudo nix-collect-garbage -d";
      nD = "sudo nix-env --delete-generations +3 -p /nix/var/nix/profiles/system";
      nf = "sudo nix flake update";
      nb = "sudo nixos-rebuild boot --sudo --flake ~/.config/nixos/#blob";
      zs = "sudo systemctl start zapret-rust.service";
      ze = "sudo systemctl stop zapret-rust.service";
      zS = "systemctl status zapret-rust.service";
      zl = "journalctl -u zapret-rust.service -b --no-pager -n 50";
      zr = "sudo systemctl restart zapret-rust.service";
      cwd = "pwd";
      npm = "pnpm";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

      alias vi="hx"
      alias nano="hx"
      alias nn="sudo nixos-rebuild switch --flake ~/.config/nixos/#blob"
      alias nd="sudo nix-collect-garbage -d"
      alias nD="sudo nix-env --delete-generations +3 -p /nix/var/nix/profiles/system"
      alias nf="nix flake update"
      alias nb="nixos-rebuild boot --sudo --flake ~/.config/nixos/#blob"
      alias zs="sudo systemctl start zapret-rust.service"
      alias ze="sudo systemctl stop zapret-rust.service"
      alias zS="systemctl status zapret-rust.service"
      alias zl="journalctl -u zapret-rust.service -b --no-pager -n 50"
      alias zr="sudo systemctl restart zapret-rust.service"
      alias cwd="pwd"
      alias npm="pnpm"
    '';
  };
}