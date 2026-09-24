{ self, inputs, ... }: {
  flake.nixosConfigurations.blob = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.blobConfiguration
    ];
  };
}
