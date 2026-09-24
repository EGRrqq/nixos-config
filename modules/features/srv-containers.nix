# modules/features/srv-containers.nix
{ self, inputs, ... }:
{
  flake.nixosModules.containers =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.myModules.containers;
      isPodman = cfg.backend == "podman";
    in
    {
      options.myModules.containers = {
        backend = lib.mkOption {
          type = lib.types.enum [ "podman" "docker" "none" ];
          default = "podman";
          description = ''
            Container engine to use.
            "podman" enables rootless podman with a docker-compatible CLI and socket.
            "docker" enables the regular docker daemon.
            "none" disables all container support.
          '';
        };
      };

      config = lib.mkIf (cfg.backend != "none") {
        virtualisation.containers.enable = true;

        virtualisation.podman = lib.mkIf isPodman {
          enable = true;
          dockerCompat = true;
          dockerSocket = {
            enable = true;
          };
          defaultNetwork.settings.dns_enabled = true;
        };

        virtualisation.docker = lib.mkIf (!isPodman) {
          enable = true;
          enableOnBoot = true;
        };

        virtualisation.oci-containers.backend = cfg.backend;

        users.users.egr =
          {
            extraGroups = [ (if isPodman then "podman" else "docker") ];
          }
          // lib.optionalAttrs isPodman {
            # Needed for rootless podman
            subUidRanges = [
              {
                startUid = 100000;
                count = 65536;
              }
            ];
            subGidRanges = [
              {
                startGid = 100000;
                count = 65536;
              }
            ];
          };

        environment.systemPackages = with pkgs; [
          docker-compose
        ];
      };
    };
}