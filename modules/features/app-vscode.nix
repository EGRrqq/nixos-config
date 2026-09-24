{ self, inputs, ... }:
{
  flake.nixosModules.vscode =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          vscode = prev.vscode.override {
            commandLineArgs = [
              "--password-store=gnome-libsecret"
              "--enable-wayland-ime=true"
            ];
          };
        })
      ];
    };
}
