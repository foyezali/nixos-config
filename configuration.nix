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
    # If you use fingerprint reader, add: "input"
  };

  # ── Boot ───────────────────────────────────────────────────────────────────
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme1n1";    # second NVMe
  boot.loader.grub.useOSProber = true;         # detect Windows on nvme0n1
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  # ── Filesystems ─────────────────────────────────────────────────────────────
  # EFI — shared with Windows (on nvme0n1p1)
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/A12C-8640";
    fsType = "vfat";
  };

  # Root — fresh ext4, was Arch root
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e28ff2a4-a15c-4f87-b38d-edd57a810489";
    fsType = "ext4";
  };

  # Home — keep existing, your data
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/32023d65-15c6-4acb-836f-5ceae9802ae9";
    fsType = "ext4";
  };

  # Swap
  swapDevices = [
    { device = "/dev/disk/by-uuid/3b9c060f-4660-460b-a152-8b20f7ae311c"; }
  ];

  # ── GPU ─────────────────────────────────────────────────────────────────────
  # ThinkPad P1 Gen 3: Intel UHD Graphics (iGPU) + NVIDIA Quadro T2000 (dGPU)

  services.xserver.enable = true;

  # Intel iGPU — used for display output
  services.xserver.videoDrivers = [ "intel" ];
  hardware.graphics.enable = true;

  # NVIDIA Quadro T2000 — for CUDA workloads only (not display)
  # Let NixOS pick the right driver version automatically
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
  };

  # ── Niri (Wayland compositor) ───────────────────────────────────────────────
  programs.niri.enable = true;

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

  # ── Display ──────────────────────────────────────────────────────────────────
  # Laptop screen resolution detected automatically. Niri handles its own display config.

  # ── Power (ThinkPad P1 Gen 3) ────────────────────────────────────────────────
  services.tlp = {
    enable = true;
    settings = {
      # CPU
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # ThinkPad P1 Gen 3 — Intel 10th Gen + Quadro
      # Adjust if you have the RTX 5000 variant
      RUNTIME_PM_DRIVER_BLACKLIST = "nvidia";
      USB_AUTOSUSPEND = true;
      RESTORE_DEVICE_STATE_ON_STARTUP = true;

      # Battery care ( ThinkPad rapid charge — adjust to your preference)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # ── Nix ──────────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  programs.nix-ld.enable = true;

  # ── System state ─────────────────────────────────────────────────────────────
  system.stateVersion = "25.05";
}
