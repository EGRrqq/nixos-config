{ inputs, ... }:

{
  imports = [
    inputs.zapret-rust.nixosModules.zapret-rust
  ];

  services.zapret-rust = {
    enable = true;
    interface = "any";
    strategy = "general (EXP).bat";
    backend = "nftables";
    gamefilterTcp = true;
    gamefilterUdp = true;
  };

  systemd.services.zapret-rust = {
    wantedBy = [ "multi-user.target" ];
  };
}
