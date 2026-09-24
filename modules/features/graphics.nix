{ self, inputs, ... }:
{
  flake.nixosModules.graphics =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # Enable graphics
      hardware.graphics.enable = true;

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      };

      # Wayland / XWayland
      services.xserver.enable = true;

      # Configure keymap in X11 — должен совпадать с Niri
      services.xserver.xkb = {
        layout = "us,ru";
        variant = "";
      };

      # Portals
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
      };
    };
}
