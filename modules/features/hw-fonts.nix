{ self, inputs, ... }:
{
  flake.nixosModules.fonts = { pkgs, lib, ... }: {
    # Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };
}
