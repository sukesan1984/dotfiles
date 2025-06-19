{ config, pkgs, ... }:

{
  home.username = "kosuke.506";
  home.homeDirectory = "/Users/kosuke.506";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.git
    pkgs.tmux
    pkgs.lsd
    pkgs.fzf
    pkgs.fzf-zsh
    pkgs.silicon
    pkgs.direnv
    pkgs.python3
    pkgs.clang-tools
    pkgs.gopls
    pkgs.ripgrep
    pkgs.nodejs
    pkgs.gnupg
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".tmux.conf".source = ~/dev/src/github.com/sukesan1984/dotfiles/.tmux.conf;
    ".zshrc".source = ~/dev/src/github.com/sukesan1984/dotfiles/.zshrc;
    ".fzf.zsh".source = ~/dev/src/github.com/sukesan1984/dotfiles/.fzf.zsh;
    ".config/nvim".source = ~/dev/src/github.com/sukesan1984/dotfiles/.config/nvim;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kosuke.506/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    VIMRUNTIME = "${pkgs.neovim}/share/nvim/runtime";
  };

  programs.fzf = {
      enableZshIntegration = true;
  };
  programs.lsd = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Kosuke Takami";
    userEmail = "kosuke.506@studist.jp";
    signing = {
      key = "1CAEB5D793EBADC3A";
      signByDefault = true;
    }
    extraConfig = {
      tag = {
        gpgSign = true;
      };
    };

  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
        vim-fugitive
        vim-nix
        vim-go
        vim-vue

        ## UI
        lightline-vim
        tagbar
        {
           plugin = kanagawa-nvim;
           config = ''
             colorscheme kanagawa
           '';
        }

        ## File management
        vim-devicons
        nvim-tree-lua

        ##FZF
        fzf-vim
    ];


    # 環境変数を確実に設定
    extraConfig = ''
      let $VIMRUNTIME = "${pkgs.neovim}/share/nvim/runtime"
    '';

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
