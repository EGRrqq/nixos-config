# modules/features/niri.nix
{ self, inputs, ... }:
{
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
  };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.noctalia)
          ];
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ru";

          layout.gaps = 5;

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.wezterm;
            "Mod+W".close-window = { };
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
          };
          debug = {
            # Отключает аппаратный слой курсора, заставляя Niri рисовать его
            # вместе с остальным кадром. Это обходит баг драйвера NVIDIA (noise around cursor)
            disable-cursor-plane = { };
          };
        };
      };
    };
}
