# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

# Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Enable networking
networking.networkmanager.enable = true;
# nftables
networking.nftables.enable = true;

# Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Enable bluetooth
  hardware.bluetooth.enable = true;

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

# Enable the X11 windowing system.
  services.xserver.enable = true;

# Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

# Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
  };

# Enable OpenGL
  hardware.graphics = {
    enable = true;
  };
# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
# Modesetting is required.
    modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
    powerManagement.enable = true;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
# powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
# Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

# Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.egr = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
        wezterm
        helix
        jetbrains.webstorm
        jetbrains.clion
        jetbrains.rider
        zed-editor
        qwen-code
        gemini-cli
        ollama
        lmstudio

        biome

        brave
        chromium

        telegram-desktop
        obsidian
        mpv

        amnezia-vpn
        wgcf
        warp-plus
        nftables
        zapret

        bespokesynth
        # natron
        blender

        kid3
    ];
    shell = pkgs.nushell;
  };

# Install firefox.
  programs.firefox.enable = true;

# Enable amnezia background service
  programs.amnezia-vpn.enable = true;

  home-manager = {
# also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "egr" = import ./home.nix;
    };
    backupFileExtension = "hm-backup";
  };

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # allow broken for natron package
  nixpkgs.config.allowBroken = true;

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
    gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi

    vscode

      git
      wget
      gnumake
      gcc15
      unzip
      xclip
      ripgrep
      fzf
      fd
      curlMinimal
      tree-sitter
      lldb_22
      gdb

      python3
      python3Packages.pip

      llvmPackages_22.clangNoLibcxx   # the compiler (uses libstdc++ to match GCC)
      llvmPackages_22.clang-tools 
      cpplint

      lua
      go
      rustc
      cargo

      nodejs_24
      corepack_24
      live-server
      deno

      gnome-tweaks

      dconf-editor
      xdotool

      nushell
      starship
      carapace
      vivid

      localsend

      appimage-run
      gearlever
      ];
  environment.variables = {
    GST_PLUGIN_SYSTEM_PATH_1_0 = "/run/current-system/sw/lib/gstreamer-1.0/";
    GST_PLUGIN_SYSTEM_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
  };

  environment.sessionVariables = rec {
    GST_PLUGIN_SYSTEM_PATH_1_0 = "/run/current-system/sw/lib/gstreamer-1.0/";
    GST_PLUGIN_SYSTEM_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
# Add any missing dynamic libraries for unpackaged programs
# here, NOT in environment.systemPackages
# stdenv.cc.cc.lib
  ];

# Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
  ];

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
networking.firewall.allowedTCPPorts = [ 53317 ];
networking.firewall.allowedUDPPorts = [ 53317 ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
