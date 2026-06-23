{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "egr";
  home.homeDirectory = "/home/egr";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (pkgs.writeShellScriptBin "qbittorrent" ''
      export QT_SCALE_FACTOR=1.5  # Adjust this value as needed
      exec ${pkgs.qbittorrent}/bin/qbittorrent "$@"
    '')
  ];

  # home.packages = with pkgs; [];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/egr/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # QT_SCALE_FACTOR = "1.5"; # Adjust this value (e.g., 1.25, 1.5, 2)
    # QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    # QT_WAYLAND_FORCE_DPI = "192"; # 200% scale (Common for 4K or Retina displays)
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git setup
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      core.editor = "hx";
      user = {

        name = "EGR";
        email = "egrrqqdev@gmail.com";
      };
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
      };
    };
  };

  # Jujutsu setup
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "EGRrqq";
        email = "egrrqqdev@gmail.com";
      };
    };
  };

  programs.nushell = {
    enable = true;
    # for editing directly to config.nu
    extraConfig = ''
            $env.config = {
             show_banner: false,
             edit_mode: vi,
             menus: [
             # Configuration for default nushell menus
             # Note the lack of source parameter
             {
                 name: completion_menu
                 only_buffer_difference: false
                 marker: "| "
                 type: {
                     layout: columnar
                     columns: 4
                     col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                     col_padding: 2
                 }
                 style: {
                     text: green
                     selected_text: green_reverse
                     description_text: blue_bold
                 }
             }
             {
                 name: history_menu
                 only_buffer_difference: true
                 marker: "? "
                 type: {
                     layout: list
                     page_size: 10
                 }
                 style: {
                     text: green
                     selected_text: green_reverse
                     description_text: blue_bold
                 }
             }
             {
                 name: help_menu
                 only_buffer_difference: true
                 marker: "? "
                 type: {
                     layout: description
                     columns: 4
                     col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
                     col_padding: 2
                     selection_rows: 4
                     description_rows: 10
                 }
                 style: {
                     text: green
                     selected_text: green_reverse
                     description_text: blue_bold
                 }
              }
             ],
             completions: {
              case_sensitive: false # case-sensitive completions
              quick: true    # set to false to prevent auto-selecting completions
              partial: true    # set to false to prevent partial filling of the prompt
              algorithm: "fuzzy"    # prefix or fuzzy
              use_ls_colors: true,
              external: {
              # set to false to prevent nushell looking into $env.PATH to find more suggestions
                 enable: true 
              # set to lower can improve completion performance at the cost of omitting some options
                 max_results: 100 
               }
              }
             }
            $env.LS_COLORS = (vivid generate ayu | str trim)
            $env.PATH = ($env.PATH | 
            prepend ($env.HOME)/.apps |
            prepend $env.HOME |
            prepend /.nix-profile/bin |
            append /usr/bin/env
            )

      # Create a directory (with parents), and immediately cd into it.
      # The --env flag propagates the PWD environment variable to the caller, which is
      # necessary to make the directory change stick.
      def --env mkcd [path: string] {
          try {
              ^mkdir -p $path   # external mkdir supports -p for parent directories
              cd $path
          } catch {
              error make {msg: $"Failed to create or cd into directory: ($path)"}
          }
      }

      # Create a temporary directory, and cd into it.
      # If no name is provided, a securely random temporary directory is created.
      def --env tmpcd [
          dirname?: string   # optional: explicit name under /tmp
      ] {
          try {
              if ($dirname != null) {
                  mkcd $"/tmp/($dirname)"   # reuse mkcd for consistent behavior
              } else {
                  let tmp = (^mktemp -d)     # external mktemp creates random temp dir
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
      nn = "sudo nixos-rebuild switch --flake ~/.config/nixos/#nixos";
      nd = "sudo nix-collect-garbage -d";
      ndd = "sudo nix-env --delete-generations +3 -p /nix/var/nix/profiles/system";
      zz = "sudo ~/repos/zapret-discord-youtube-linux/service.sh run --config ~/repos/zapret-discord-youtube-linux/conf.env";
      cwd = "pwd";
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
    '';
  };

  # programs.fnm = {
  #     enable = true;
  #     enableNushellIntegration = true;
  # };
}
