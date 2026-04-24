{ inputs, pkgs, lib, config, ... }:

{
  imports = [ ];

  home.username = "jj";
  home.homeDirectory = "/home/jj";

  # ── Packages ────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Dev
    python3
    nodejs
    # Tools
    git
    gh
    lazygit
    delta              # better git diffs
    jujutsu            # distributed VCS (like git but better)
    starship           # prompt
    zellij             # terminal multiplexer (like tmux but better)
    # Editors
    neovim
    vscode
    # Browser
    firefox
    librewolf
    # Media
    mpv
    imv                # image viewer
    zathura            # PDF viewer
    # Utils
    brightnessctl      # backlight control
    volumeicon         # tray volume
    networkmanager_dmenu
    pass               # password manager
    otp-cli
    bitwarden-cli
    # System info
    fastfetch
    # Downloads
    yt-dlp
    # Compression
    unzip
    p7zip
    ripgrep
  ];

  # ── Programs ─────────────────────────────────────────────────────────────────

  # ── Starship prompt ──────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      command_timeout = 500;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$cmd_duration"
        "$line_break"
        "$python"
        "$nodejs"
        "$rust"
        "$java"
        "$nix_shell"
        "$character"
      ];
    };
  };

  # ── Fish shell ───────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # aliases
      alias ls = exa
      alias ll = 'exa -l'
      alias la = 'exa -la'
      alias cat = bat
      alias find = 'fd'
      alias top = btop

      # zoxide for smarter cd
      zoxide init fish | source
    '';
  };

  # ── Git ──────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "foyez";
    userEmail = "foyez@protonmail.com";  # replace with your email
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD~1";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      rerere.enabled = true;
      diff.algorithm = "histogram";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.features = "side-by-side";
    };
  };

  # ── Neovim ────────────────────────────────────────────────────────────────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withPython3 = false;
    withRuby = false;
    extraConfig = ''
      set hidden
      set number
      set relativenumber
      set cursorline
      set termguicolors
      set mouse=a
      set clipboard=unnamedplus
      set splitright
      set splitbelow
      set encoding=utf-8
    '';
  };

  # ── Firefox / Librewolf ───────────────────────────────────────────────────────
  programs.firefox = {
    enable = true;
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
    };
  };

  # ── Zellij ────────────────────────────────────────────────────────────────────
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  # ── Lazygit ───────────────────────────────────────────────────────────────────
  programs.lazygit = {
    enable = true;
  };

  # ── Niri ─────────────────────────────────────────────────────────────────────
  # Link your niri config (KDL format)
  home.file.".config/niri/config.kdl".source = ./niri/config.kdl;

  # ── Waybar ────────────────────────────────────────────────────────────────────
  # If you want a status bar (niri has a built-in minimal bar, waybar is fuller)
  # programs.waybar = {
  #   enable = true;
  #   settings = {
  #     "wlr/workspaces" = { };
  #     "river/tags" = { };
  #     "custom/media" = { };
  #     "river/sndio" = { };
  #     "river/battery" = { };
  #     "river/keyboard" = { };
  #     "tray" = { };
  #     "clock" = { };
  #   };
  # };

  # ── Dotfiles ─────────────────────────────────────────────────────────────────
  # If your dotfiles are in a git repo:
  # home.file.".dotfiles".source = /path/to/your/dotfiles;

  # ── Home Manager ─────────────────────────────────────────────────────────────
  home.stateVersion = "25.05";
}
