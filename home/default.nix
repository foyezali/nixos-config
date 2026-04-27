{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.username = "foyez";
  home.homeDirectory = "/home/foyez";

  # ============================================
  # User packages
  # ============================================
  home.packages = with pkgs; [
    fish
    starship
    eza
    bat
    fd
    ripgrep
    fzf
    zoxide
    neovim
    fastfetch

    # Launchers / bars (Noctalia replaces waybar but wofi is still useful)
    wofi
    fuzzel

    # Notification daemon
    mako

    # Terminal
    alacritty

    # VSCode keyring fix (Wayland)
    gnome3.gnome-keyring
  ];

  # ============================================
  # Niri (home-manager module)
  # ============================================
  programs.niri = {
    enable = true;
    settings = {
      # ThinkPad P1 Gen 3 display
      outputs."eDP-1".mode = "1920x1080@60";

      # Layout
      layout.gaps = 16;

      # Keybindings
      binds = {
        # Mod=Super/Win key
        "Mod+Return" = { spawn = [ "alacritty" ]; };
        "Mod+Q" = { close-window = { }; };
        "Mod+D" = { spawn = [ "wofi" ]; };
        "Mod+Space" = { toggle-window-floating = { }; };
        "Mod+F" = { fullscreen-window = { }; };
        "Mod+Left" = { focus-column-left = { }; };
        "Mod+Right" = { focus-column-right = { }; };
        "Mod+Down" = { focus-window-down = { }; };
        "Mod+Up" = { focus-window-up = { }; };

        # Move windows
        "Mod+Shift+Left" = { move-window-left = { }; };
        "Mod+Shift+Right" = { move-window-right = { }; };
        "Mod+Shift+Down" = { move-window-down = { }; };
        "Mod+Shift+Up" = { move-window-up = { }; };

        # Restart niri
        "Mod+Shift+R" = { spawn = [ "systemctl" "--user" "restart" "niri" ]; };
      };

      # Input
      input.keyboard.xkb.options = [ "caps:escape" ];
      input.touchpad.tap = true;

      # Environment
      environment = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "XDG_CURRENT_DESKTOP" = "noctalia";
        "XDG_SESSION_TYPE" = "wayland";
        "XDG_SESSION_DESKTOP" = "noctalia";
      };
    };

    # Spawn Noctalia on startup (runs on top of niri)
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };

  # ============================================
  # Noctalia Shell
  # ============================================
  programs.noctalia-shell = {
    enable = true;

    # Minimal starting config — extend as needed
    settings = {
      # Bar
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "Clock"; }
          ];
          center = [
            { id = "Workspace"; }
          ];
          right = [
            { id = "Tray"; }
            { id = "Battery"; }
            { id = "Volume"; }
            { id = "Clock"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      # Colour scheme
      colorSchemes.predefinedScheme = "Monochrome";

      # General
      general = {
        radiusRatio = 0.2;
      };
    };
  };

  # ============================================
  # Fish shell
  # ============================================
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      alias ls eza
      alias ll 'eza -l'
      alias la 'eza -la'
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # ============================================
  # State version
  # ============================================
  home.stateVersion = "25.11";
}
