{ self, inputs, ... }:
{
  flake.nixosModules.bluetooth = { pkgs, lib, ... }: {
    # Enable bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true; # Powers on the Bluetooth controller at startup
      settings = {
        General = {
          Experimental = true; # Enables experimental features like battery charge reporting
        };
      };
    };
  };
}
