{ inputs, pkgs, lib, config, ... }:

{
  home.username = "jj";
  home.homeDirectory = "/home/jj";

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
}
