{ inputs, pkgs, lib, config, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

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
    starship           # prompt
    zellij             # terminal multiplexer (like tmux but better)
    # Editors — neovim is in system packages
    # Browser — firefox managed by programs.firefox
    # Media
    mpv
    imv                # image viewer
    zathura            # PDF viewer
    # Utils
    brightnessctl      # backlight control
    networkmanagerapplet  # tray network manager
    pass               # password manager
    bitwarden-cli
    # System info
    fastfetch
    # Downloads
    yt-dlp
    # Compression
    unzip
    p7zip
  ];

  # ── Noctalia Shell ─────────────────────────────────────────────────────────
  programs.noctalia-shell = {
    enable = true;
    settings = {
      # Let Noctalia pick up wallpaper colors automatically
      colorSchemes = {
        useWallpaperColors = true;
        darkMode = true;
      };
      # Bar at top
      bar = {
        position = "top";
        floating = false;
        backgroundOpacity = 0.9;
      };
    };
  };

  # ── Programs ─────────────────────────────────────────────────────────────────

  # ── Starship prompt ──────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
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
      # aliases (fish uses space-separated syntax, not =)
      alias ls eza
      alias ll 'eza -l'
      alias la 'eza -la'
      alias cat bat
      alias find fd
      alias top btop

      # zoxide for smarter cd
      zoxide init fish | source
    '';
  };

  # ── Git ──────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "foyez";
      user.email = "foyez@protonmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      rerere.enabled = true;
      diff.algorithm = "histogram";
    };
    settings.alias = {
      co = "checkout";
      br = "branch";
      st = "status";
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD~1";
    };
  };

  # ── Neovim ────────────────────────────────────────────────────────────────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
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
  };

  # ── Lazygit ───────────────────────────────────────────────────────────────────
  programs.lazygit = {
    enable = true;
  };

  # ── Niri ─────────────────────────────────────────────────────────────────────
  # Link your niri config (KDL format)
  home.file.".config/niri/config.kdl".source = ./niri/config.kdl;

  # ── Home Manager ─────────────────────────────────────────────────────────────
  home.stateVersion = "25.05";
}
