# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL


{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "nixos";
    startMenuLaunchers = true;
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure gnome desktop env + display manager
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;

       # To use Flatpak you must enable XDG Desktop Portals with xdg.portal.enable.
xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Enable flatpak
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
  };

  # Enable bluetooth
  # hardware.bluetooth.enable = true;

  # nixpkgs.config.permittedInsecurePackages = [
  #   "libtiff-4.0.3-opentoonz"
  # ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.egrqq = {
    isNormalUser = true;
    description = "egrqq";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
    shell = pkgs.nushell;
  };

  # Enable amnezia background service
  # programs.amnezia-vpn.enable = true;

  # define home-manager
  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "egrqq" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    helix 

    go
    rustc
    cargo

    wget
    git
    gnumake
    gcc14
    unzip
    xclip
    ripgrep
    fzf
    fd

    nodejs_23
    corepack_23
    live-server

    elmPackages.elm
    gleam
    erlang_27
    rebar3
    inotify-tools

    nushell
    starship
    carapace
    vivid
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # # Enable OpenGL
  # hardware.graphics = {
  #   enable = true;
  # };
  # # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = ["nvidia"];
  # hardware.nvidia = {
  #   # Modesetting is required.
  #   modesetting.enable = true;
  #
  #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #   # Enable this if you have graphical corruption issues or application crashes after waking
  #   # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
  #   # of just the bare essentials.
  #   powerManagement.enable = true;
  #
  #   # Fine-grained power management. Turns off GPU when not in use.
  #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #   # powerManagement.finegrained = false;
  #
  #   # Use the NVidia open source kernel module (not to be confused with the
  #   # independent third-party "nouveau" open source driver).
  #   # Support is limited to the Turing and later architectures. Full list of 
  #   # supported GPUs is at: 
  #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
  #   # Only available from driver 515.43.04+
  #   # Currently alpha-quality/buggy, so false is currently the recommended setting.
  #   open = false;
  #
  #   # Enable the Nvidia settings menu,
  #   # accessible via `nvidia-settings`.
  #   nvidiaSettings = true;
  #
  #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #   package = config.boot.kernelPackages.nvidiaPackages.beta;
  # };
  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
