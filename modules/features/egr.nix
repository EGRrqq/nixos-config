{ self, inputs, ... }:
{
  flake.nixosModules.userEgr = { pkgs, lib, ... }: {
    users.users.egr = {
      isNormalUser = true;
      description = "egr";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.nushell;
      packages = with pkgs; [ ];
    };

    environment.shells = [ pkgs.nushell ];
  };
}
