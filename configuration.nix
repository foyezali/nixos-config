{ config, pkgs, inputs, ... }:

{
  # Import hardware config
  imports = [ ./hardware-configuration.nix ];

  # Bootloader — systemd-boot on EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # Networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Europe/London";

  # Internationalisation
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # ============================================
  # Niri Wayland Compositor
  # ============================================
  # NixOS-level module handles: systemd service, polkit, keyring,
  # xdg-desktop-portal, and installing the niri package.
  # Actual config (keybinds, outputs, etc.) is in home-manager.nix
  programs.niri.enable = true;

  # ============================================
  # Required services for Noctalia
  # ============================================
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ============================================
  # Audio — PipeWire
  # ============================================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================
  # Printing
  # ============================================
  services.printing.enable = true;

  # ============================================
  # Tailscale
  # ============================================
  services.tailscale.enable = true;

  # ============================================
  # Logitech wireless
  # ============================================
  hardware.logitech.wireless.enable = true;

  # ============================================
  # User account
  # ============================================
  users.users.foyez = {
    isNormalUser = true;
    description = "foyez";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # ============================================
  # System-wide packages
  # ============================================
  environment.systemPackages = with pkgs; [
    # Shells
    fish
    starship

    # Utils
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    fastfetch

    # Editors
    neovim
    vscode
    jetbrains.idea
    jetbrains.pycharm

    # Browsers
    librewolf
    floorp-bin

    # Communication
    element-desktop
    protonmail-desktop

    # VPN
    tailscale
    protonvpn-gui

    # Passwords
    bitwarden-desktop
    bitwarden-cli
    proton-pass

    # Cloud
    nextcloud-client
    immich
    immich-cli

    # Media
    vlc
    mpv

    # GNOME Extensions (as CLI tools)
    gnomeExtensions.gsconnect
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status

    # System
    solaar
    git
    gh
  ];

  # ============================================
  # Allow unfree packages
  # ============================================
  nixpkgs.config.allowUnfree = true;

  # ============================================
  # Binary caches — skip compiling niri/noctalia
  # ============================================
  nix.settings.substituters = [
    "https://niri.cachix.org"
    "https://noctalia.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "niri.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  # ============================================
  # Version
  # ============================================
  system.stateVersion = "25.11";
}
