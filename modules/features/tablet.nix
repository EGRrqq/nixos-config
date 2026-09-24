{ self, inputs, ... }:
{
  flake.nixosModules.tablet = { pkgs, lib, ... }: {
    # Enable OpenTabletDriver
    hardware.opentabletdriver.enable = true;

    # Required by OpenTabletDriver
    hardware.uinput.enable = true;
    boot.kernelModules = [
      "uinput"
      "snd-seq"
      "snd-rawmidi"
    ];
  };
}
