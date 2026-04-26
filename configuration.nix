{ inputs, pkgs, lib, ... }:

{
  imports = [ ];

  # ── Host info ──────────────────────────────────────────────────────────────
  networking.hostName = "p1-gen3";

  # ── User ─────────────────────────────────────────────────────────────────
  users.users.foyez = {
    isNormalUser = true;
    description = "foyez";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
    ];
  };

  # ── Boot ─────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Filesystems ───────────────────────────────────────────────────────────
  # New install: root on 9a946700, home+swap on old partitions
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9a946700-8da8-4bbf-94f3-cdb04b42c331";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A12C-8640";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/32023d65-15c6-4acb-836f-5ceae9802ae9";
    fsType = "ext4";
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/3b9c060f-4660-460b-a152-8b20f7ae311c"; }
  ];

  # ── GPU — Intel only ──────────────────────────────────────────────────────
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];

  # ── Niri ──────────────────────────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Software renderer — required for NVIDIA Optimus on ThinkPad P1 ─────────
  environment.sessionVariables = {
    WLR_RENDERER = "sw";
  };

  # ── Disable GNOME/GDM ─────────────────────────────────────────────────────
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # ── Greetd + Niri ────────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "env WLR_RENDERER=sw ${pkgs.niri}/bin/niri";
        user = "foyez";
      };
      default_session = {
        command = "env WLR_RENDERER=sw ${pkgs.niri}/bin/niri";
        user = "foyez";
      };
    };
  };

  # ── Fonts ────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
  ];

  # ── Locale ────────────────────────────────────────────────────────────────
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  # ── Basic utils ──────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    git
    fish
    alacritty
  ];

  # ── Sound ────────────────────────────────────────────────────────────────
  services.pipewire.enable = true;

  # ── Network ──────────────────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  # ── Nix ─────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── System state ────────────────────────────────────────────────────────
  system.stateVersion = "25.11";
}
