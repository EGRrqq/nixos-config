{ self, inputs, ... }:
{
  flake.nixosModules.security = { lib, pkgs, ... }: {
    security.polkit.enable = true;
  };
}
