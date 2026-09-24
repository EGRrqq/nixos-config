{ self, inputs, ... }:
{
  flake.nixosModules.printing = { pkgs, lib, ... }: {
    # Enable CUPS to print documents.
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
    };
  };
}
