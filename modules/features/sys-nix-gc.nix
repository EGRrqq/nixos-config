{ self, inputs, ... }:
{
  flake.nixosModules.nixGc =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Automatic garbage collection
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      # Deduplicate identical files in the Nix store
      nix.settings.auto-optimise-store = true;

      # Keep at most 5 system generations in the boot menu
      boot.loader.systemd-boot.configurationLimit = 5;
    };
}
