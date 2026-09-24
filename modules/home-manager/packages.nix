{ self, inputs, ... }:
{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      (pkgs.writeShellScriptBin "qbittorrent" ''
        export QT_SCALE_FACTOR=1.5
        export QT_AUTO_SCREEN_SCALE_FACTOR=0   # отключает авто-масштаб Qt
        exec ${pkgs.qbittorrent}/bin/qbittorrent "$@"
      '')

      bitwarden-desktop
      localsend
    ];

    xdg.desktopEntries.lmstudio = {
      name = "LM Studio";
      exec = "${pkgs.writeShellScriptBin "lmstudio" ''
        exec ${pkgs.lmstudio}/bin/lm-studio --force-device-scale-factor=1.8 "$@"
      ''}/bin/lmstudio";
      icon = "lm-studio";
      categories = [ "Development" ];
      terminal = false;
    };
  };
}
