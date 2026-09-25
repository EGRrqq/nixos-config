{ pkgs, config, lib, ... }:
{
  programs.carapace = {
    enable = true;
  };

  programs.bash = {
    enable = true;
  };

  # Managed in a self-hosted git repo:
  #   ~/.config/bash/.bashrc
  #   ~/.config/starship/starship.toml
  #   ~/.config/nushell/config.nu
  home.file.".bashrc" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/bash/.bashrc";
  };
}