{ self, inputs, ... }:
{
  flake.nixosModules.displayManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.myModules.displayManager;
    in
    {
      # 1. Объявляем собственные опции
      options.myModules.displayManager = {
        enable = lib.mkEnableOption "GDM display manager";

        defaultSession = lib.mkOption {
          type = lib.types.str;
          default = "niri";
          description = "Сессия, запускаемая по умолчанию";
        };

        autoLogin = {
          enable = lib.mkEnableOption "auto-login";
          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Пользователь для автоматического входа";
          };
        };
      };

      # 2. Применяем настройки, только если enable = true
      config = lib.mkIf cfg.enable {
        services.displayManager = {
          gdm.enable = true;
          inherit (cfg) defaultSession;
        }
        // lib.optionalAttrs cfg.autoLogin.enable {
          autoLogin = {
            enable = true;
            inherit (cfg.autoLogin) user;
          };
        };
      };
    };
}
