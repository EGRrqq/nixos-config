{ self, inputs, ... }:
{
  flake.nixosModules.brave =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          brave = prev.brave.override {
            commandLineArgs = [ "--password-store=gnome-libsecret" "--force-device-scale-factor=1.3" ];
          };
        })
      ];
    };
}
