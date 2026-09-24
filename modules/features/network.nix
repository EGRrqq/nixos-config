{ self, inputs, ... }:
{
  flake.nixosModules.network = { lib, pkgs, ... }: {
    networking.networkmanager.enable = true;
    networking.nftables.enable = true;

    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    networking.nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    # Open ports in the firewall.
    networking.firewall = {
      enable = true;
      # - 53317 for localsend app
      allowedTCPPorts = [
        53317
      ];
      allowedUDPPorts = [
        53317
      ];
    };
  };
}
