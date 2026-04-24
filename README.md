# NixOS Config — foyez laptop

Fresh NixOS setup with Niri + home-manager. Declarative, reproducible, and ready to evolve.

## Structure

```
nixos-config/
├── flake.nix              # Flake inputs + nixosConfiguration definition
├── configuration.nix      # System-level config (boot, filesystem, GPU, services)
├── home/
│   ├── default.nix        # home-manager: user packages, programs, dotfiles
│   └── niri/
│       └── config.kdl    # Niri compositor config
└── README.md
```

## Before install

### 1. Get your /home partition UUID
Boot into Arch and run:
```bash
blkid | grep home
# Output: /dev/sdaX: UUID="xxxx-xxxx" TYPE="ext4" PARTUUID="..."
```
Copy that UUID and put it in `configuration.nix` under `fileSystems."/home".device`.

### 2. Check your disk
```bash
lsblk
```
Is Arch on `/dev/sda` or `/dev/nvme0n1`? Update `boot.loader.grub.device` accordingly.

### 3. Windows boot entry
`boot.loader.grub.useOSProber = true` will auto-detect Windows — if that breaks, set it to `false` and add a manual entry.

## Install

### 1. Boot NixOS live USB
Get the installer from https://nixos.org/download

### 2. Partition (if nuking Arch)
```bash
# List drives
lsblk

# Partition your disk (example for single drive)
# cfdisk /dev/sda
#  - EFI: +500M, type EFI System
#  - / (root): rest, type Linux
```

### 3. Mount existing /home
```bash
mount /dev/disk/by-uuid/YOUR_HOME_UUID /mnt/home
```

### 4. Clone your config (from another machine or git)
```bash
git clone https://github.com/yourusername/nixos-config /mnt/etc/nixos
# Or copy it via USB/scp
```

### 5. Install
```bash
cd /mnt/etc/nixos
nixos-install --flake .#laptop
```

### 6. Set root password, reboot

## Daily workflow

```bash
# Edit configs
nvim configuration.nix   # system
nvim home/default.nix    # user env

# Apply changes
sudo nixos-rebuild switch --flake .#laptop

# Or for the user env only (no root needed)
home-manager switch --flake .#laptop

# Update flake inputs (nixpkgs, etc.)
nix flake update
```

## Rollback

```bash
# List generations
nixos-rebuild list-generations --flake .#laptop

# Boot into any previous generation from the GRUB menu

# Or rollback without rebooting
sudo nixos-rebuild switch --generation -1 --flake .#laptop
```

## First things after install

```bash
# Copy your existing dotfiles over
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles && stow .

# Import your Neovim config (ml4w or whatever)
git clone https://github.com/yourusername/nvim-config ~/.config/nvim

# Install Firefox extensions (usually synced via your account anyway)

# Set up passwords
pass init your-gpg-key-id
```

## Hardware-specific notes

- **ThinkPad**: TLP is enabled in configuration.nix, adjust charge thresholds
- **NVIDIA**: Uncomment the NVIDIA section in configuration.nix — you'll also need `services.xserver.videoDrivers = [ "nvidia" ]` and possibly a custom kernel module config
- **Mac**: Different trackpad/keyboard inputs, more finicky GPU setup

## Extending

### Add a package
```nix
# in home/default.nix
home.packages = with pkgs; [
  existing...
  new-package
];
```

### Add a program config
```nix
programs.newprogram = {
  enable = true;
  # ...
};
```

### Add a system service
```nix
# in configuration.nix
services.newservice = {
  enable = true;
  # ...
};
```

### Shell aliases
```nix
# in home/default.nix → programs.fish.interactiveShellInit
alias myalias = "actual command"
```

## Next-level

- **Secrets management**: Use `sops-nix` or `agenix` for encrypted secrets
- **Impermanence**: Make `/nix/store` the only persistent state (stateless system)
- **Nix Darwin**: Use the same config language on macOS
- **Deploy to Hetzner VPS**: Same flake, different host — your laptop config can deploy your server config
