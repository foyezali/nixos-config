{ inputs, pkgs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  home.username = "foyez";
  home.homeDirectory = "/home/foyez";

  # Niri config
  programs.niri = {
    package = inputs.niri.packages.${pkgs.system}.niri-unstable;
    settings = {
      layout.gaps = 16;

      binds = {
        "Mod+Return".action.spawn = [ "alacritty" ];
        "Mod+Q".action.close-window = [ ];
        "Mod+D".action.spawn = [ "wofi" ];
        "Mod+Space".action.toggle-window-floating = [ ];
        "Mod+F".action.fullscreen-window = [ ];
        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Shift+Left".action.move-column-left = [ ];
        "Mod+Shift+Right".action.move-column-right = [ ];
        "Mod+Shift+Down".action.move-window-down = [ ];
        "Mod+Shift+Up".action.move-window-up = [ ];
        "Mod+Shift+R".action.spawn = [ "systemctl" "--user" "restart" "niri" ];
      };

      input.keyboard.xkb.options = "caps:escape";
      input.touchpad.tap = true;

      environment = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "XDG_CURRENT_DESKTOP" = "noctalia";
        "XDG_SESSION_TYPE" = "wayland";
        "XDG_SESSION_DESKTOP" = "noctalia";
      };

      spawn-at-startup = [
        { argv = [ "${inputs.noctalia.packages.${pkgs.system}.default}/bin/noctalia-shell" ]; }
      ];
    };
  };

  # Remove old niri config so home-manager can write the new one
  home.activation = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    rm -f ~/.config/niri/config.kdl
  '';

  # Force overwrite fish config
  xdg.configFile."fish/config.fish".force = true;

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
