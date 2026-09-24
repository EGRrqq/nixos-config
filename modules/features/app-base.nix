{ self, inputs, ... }:
{
  flake.nixosModules.basePackages = { lib, pkgs, ... }: {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    environment.systemPackages = with pkgs; [
      xwayland-satellite

      # Terminals & editors
      wezterm
      neovim
      helix
      vscode
      brave

      opencode
      aider-chat-full

      # Shell tools
      nushell
      starship
      carapace
      vivid

      # CLI utilities
      git
      gh
      unzip
      wget
      fzf
      ripgrep
      tree-sitter
      fd
      sshs
      wl-clipboard

      python314
      python314Packages.pip
      python314Packages.jupyterlab

      llvmPackages_23.clangNoLibcxx # the compiler (uses libstdc++ to match GCC)
      llvmPackages_23.clang-tools
      cpplint

      lua
      luau
      go
      rustc
      cargo
      php

      nodejs-slim_26
      biome
      corepack
      live-server
      bun
      deno

      vial

      # Apps
      localsend
      bitwarden-desktop
      swaylock
      playerctl
      brightnessctl
    ];
  };
}
