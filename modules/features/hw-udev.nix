{ self, inputs, ... }:
{
  flake.nixosModules.udev = { lib, pkgs, ... }: {
    services.udev.packages = with pkgs; [
      vial
      qmk
      qmk-udev-rules
    ];

    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01a1", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}
