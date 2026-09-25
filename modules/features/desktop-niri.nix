# modules/features/desktop-niri.nix
{ ... }:
{
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;
  };
}