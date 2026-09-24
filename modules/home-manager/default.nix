{ self, inputs, ... }:
{
  flake.modules.homeManager.egr = { pkgs, ... }: {
    imports = [
      self.homeModules.shell
      self.homeModules.git
      self.homeModules.ssh
      self.homeModules.packages
    ];

    home.username = "egr";
    home.homeDirectory = "/home/egr";
    home.stateVersion = "26.05";
    programs.home-manager.enable = true;
  };
}
