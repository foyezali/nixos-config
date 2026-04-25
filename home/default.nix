{ inputs, pkgs, lib, config, ... }:

{
  home.username = "foyez";
  home.homeDirectory = "/home/foyez";

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
    alacritty
    fastfetch
  ];

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

  home.stateVersion = "25.05";

  # Manage niri config
  home.file.".config/niri/config.kdl" = {
    source = ./niri/config.kdl;
  };
}
