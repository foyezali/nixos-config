{ inputs, pkgs, lib, ... }:

{
  imports = [ ];

  # ── Host info ──────────────────────────────────────────────────────────────
  networking.hostName = "p1-gen3";

  # ── User ───────────────────────────────────────────────────────────────────
  users.users.jj = {
    isNormalUser = true;
    description = "jj";
    extraGroups = [
      "wheel"        # sudo
      "video"        # GPU
      "audio"        # sound
      "input"        # input devices
      "networkmanager" # network control
    ];
    # password set imperatively — change with `passwd jj`
  };

  # ── Boot ───────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # ── Filesystems ─────────────────────────────────────────────────────────────
  # EFI — shared with Windows (on nvme1n1p1)
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/A12C-8640";
    fsType = "vfat";
  };

  # Root — nvme0n1p4
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/453ef787-4e32-42f5-bb9f-3570531f57dc";
    fsType = "ext4";
  };

  # Home — nvme0n1p3
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/32023d65-15c6-4acb-836f-5ceae9802ae9";
    fsType = "ext4";
  };

  # Swap — nvme0n1p2
  swapDevices = [
    { device = "/dev/disk/by-uuid/3b9c060f-4660-460b-a152-8b20f7ae311c"; }
  ];

  # ── GPU ─────────────────────────────────────────────────────────────────────
  # ThinkPad P1 Gen 3: Intel UHD Graphics (iGPU) + NVIDIA Quadro T2000 (dGPU)
  services.xserver.enable = true;

  # Intel iGPU — used for display output
  services.xserver.videoDrivers = [ "intel" ];

  # NVIDIA Quadro T2000 — for CUDA workloads only (not display)
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    prime.offload.enable = true;
  };

  # ── Niri (Wayland compositor) ───────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Display Manager (greetd + niri) ────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      # Auto-login as jj — niri starts automatically
      initial_session = {
        command = "${pkgs.niri}/bin/niri";
        user = "jj";
      };
      # Fallback if initial_session fails
      default_session = {
        command = "${pkgs.niri}/bin/niri";
        user = "jj";
      };
    };
  };

  # ── XDG Portals (needed for Wayland apps) ──────────────────────────────────
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = [ "gtk" ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk      # GTK file picker, etc.
      xdg-desktop-portal-wlr      # screen sharing
    ];
  };

  # ── Polkit (needed for authentication in Wayland) ────────────────────────────
  security.polkit.enable = true;

  # ── Fonts ───────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [ ];

  # ── Locale ──────────────────────────────────────────────────────────────────
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  # ── Basic utils ─────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    vim
    htop
    btop
    fish
    fzf
    ripgrep
    fd
    bat
    eza
    zoxide
    procps
    pciutils
    usbutils
    neovim
  ];

  # ── Sound (Pipewire) ────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # ── Network ──────────────────────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  # ── Bluetooth ────────────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;

  # ── Nix ─────────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  programs.nix-ld.enable = true;

  # ── System state ─────────────────────────────────────────────────────────────
  system.stateVersion = "25.05";
}
