{ self, inputs, ... }:
{
  flake.nixosModules.gnomeKeyring =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Сервис GNOME Keyring — хранилище паролей для Chromium/Brave и других приложений.
      services.gnome.gnome-keyring.enable = true;

      # Автоматическая разблокировка хранилища при входе через PAM.
      # Покрываем несколько PAM-сервисов, чтобы работало и при обычном логине,
      # и при автологине (у тебя включён autoLogin в displayManager).
      security.pam.services = {
        login.enableGnomeKeyring = true;
        gdm.enableGnomeKeyring = true;
        gdm-password.enableGnomeKeyring = true;
        gdm-autologin.enableGnomeKeyring = true;
      };
    };
}
