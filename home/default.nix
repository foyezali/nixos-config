{ inputs, pkgs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  home.username = "foyez";
  home.homeDirectory = "/home/foyez";

  # Niri config
  programs.niri = {
    enable = true;
    settings = {
      layout.gaps = 16;

      binds = {
        "Mod+Return" = { spawn = [ "alacritty" ]; };
        "Mod+Q" = { close-window = { }; };
        "Mod+D" = { spawn = [ "wofi" ]; };
        "Mod+Space" = { toggle-window-floating = { }; };
        "Mod+F" = { fullscreen-window = { }; };
        "Mod+Left" = { focus-column-left = { }; };
        "Mod+Right" = { focus-column-right = { }; };
        "Mod+Down" = { focus-window-down = { }; };
        "Mod+Up" = { focus-window-up = { }; };
        "Mod+Shift+Left" = { move-window-left = { }; };
        "Mod+Shift+Right" = { move-window-right = { }; };
        "Mod+Shift+Down" = { move-window-down = { }; };
        "Mod+Shift+Up" = { move-window-up = { }; };
        "Mod+Shift+R" = { spawn = [ "systemctl" "--user" "restart" "niri" ]; };
      };

      input.keyboard.xkb.options = [ "caps:escape" ];
      input.touchpad.tap = true;

      environment = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "XDG_CURRENT_DESKTOP" = "noctalia";
        "XDG_SESSION_TYPE" = "wayland";
        "XDG_SESSION_DESKTOP" = "noctalia";
      };
    };

    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
  };

  # Noctalia shell
  programs.noctalia-shell = {
    enable = true;
    settings = {
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
      colorSchemes.predefinedScheme = "Monochrome";
      general.radiusRatio = 0.2;
    };
  };

  # Shell
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    alias ls eza
    alias ll 'eza -l'
    alias la 'eza -la'
  '';
  programs.starship.enable = true;
  programs.starship.settings.add_newline = false;

  home.stateVersion = "25.11";
}
