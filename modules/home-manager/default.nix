{ self, inputs, ... }:
{
  flake.homeModules.egr = { pkgs, ... }: {
    imports = [
      ./_fragments/shell.nix
      ./_fragments/git.nix
      ./_fragments/ssh.nix
      ./_fragments/packages.nix
      ./_fragments/yazi.nix
    ];

    home.username = "egr";
    home.homeDirectory = "/home/egr";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
  };
}