{ self, inputs, ... }:
{
  flake.modules.homeManager.ssh = { pkgs, ... }: {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";

      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_github";
          identitiesOnly = true;
        };
        "codeberg.org" = {
          hostname = "codeberg.org";
          user = "git";
          identityFile = "~/.ssh/id_ed25519_codeberg";
          identitiesOnly = true;
        };
      };
    };
  };
}
