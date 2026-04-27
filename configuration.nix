{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

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

  # Niri Wayland compositor — handles login, window management, everything
  programs.niri.enable = true;

  # Required for Noctalia
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  # Logitech
  hardware.logitech.wireless.enable = true;

  # User
  users.users.foyez = {
    isNormalUser = true;
    description = "foyez";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # All packages
  environment.systemPackages = with pkgs; [
    fish starship eza bat fd ripgrep fzf zoxide fastfetch
    neovim vscode jetbrains.idea jetbrains.pycharm
    librewolf floorp-bin
    element-desktop protonmail-desktop
    tailscale protonvpn-gui
    bitwarden-desktop bitwarden-cli proton-pass
    nextcloud-client immich immich-cli
    vlc mpv
    gnomeExtensions.gsconnect
    gnomeExtensions.tailscale-qs
    gnomeExtensions.tailscale-status
    solaar git gh
    alacritty wofi mako fuzzel
  ];

  nixpkgs.config.allowUnfree = true;

  # Binary caches
  nix.settings.substituters = [
    "https://niri.cachix.org"
    "https://noctalia.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "niri.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  system.stateVersion = "25.11";
}
