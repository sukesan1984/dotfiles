# Studist Nix Configuration
#
# このflakeは以下の設定を管理します：
# 1. darwinConfigurations: システム全体の設定（Homebrew、システム設定、home-manager統合によるユーザー設定）
#
# 使い方:
#
# nix-darwin (システム設定 + home-manager統合) - 管理者権限が必要
# 初回:
# $ sudo nix run --extra-experimental-features "nix-command flakes" nix-darwin/master#darwin-rebuild -- switch --impure --flake .#studistDarwin
#
# 2回目以降 (/run/current-system/sw/bin/ にパスが通っていれば):
# $ sudo darwin-rebuild switch --impure --flake .#studistDarwin
#
# 注意事項:
# - home-managerはnix-darwinに統合されているため、別途実行する必要はありません
{
  description = "A flake for Studist dev";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # # 特定のコミットハッシュで固定したnixpkgs（1password用）
    # nixpkgs-1password.url = "github:NixOS/nixpkgs/86e78d3d2084ff87688da662cf78c2af085d8e73";
    #
    nil.url = "github:oxalica/nil?ref=main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
  };
  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-1password,
      nil,
      home-manager,
      nix-darwin,
      nix-homebrew,
      nixpkgs-ruby,
    }:
    let
      # 共通のusername設定 - SUDO_USERまたはUSERから取得
      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          normalUser = builtins.getEnv "USER";
        in
        if sudoUser != "" then sudoUser else normalUser;

      supportedSystems = [
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        }
      );

      # # バージョンを固定するためのnixpkgs定義（1password用）
      # nixpkgs1passwordFor = forAllSystems (
      #   system:
      #   import nixpkgs-1password {
      #     inherit system;
      #     config = {
      #       allowUnfree = true;
      #     };
      #   }
      # );
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          # こっちのはnix profile install などで使う場合の定義の例示
          packages-list = pkgs.buildEnv {
            name = "packages-list";
            paths = [
              nil.packages.${system}.nil
              pkgs.git
              pkgs.curl
              # ここにパッケージを追記していく
            ];
          };
          default = self.packages.${system}.packages-list;
        }
      );

      # nix-darwin設定（home-manager統合済み）
      # システム全体の設定とユーザー個別の設定を一括管理
      darwinConfigurations =
        let
          # 共通のdarwin設定を関数として定義
          mkDarwinConfig =
            system:
            nix-darwin.lib.darwinSystem {
              pkgs = nixpkgsFor.${system};
              modules = [
                # home-manager統合
                home-manager.darwinModules.home-manager
                # homebrew本体の管理
                nix-homebrew.darwinModules.nix-homebrew
                {
                  nix-homebrew = {
                    # install homebrew under the default prefix
                    enable = true;

                    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                    enableRosetta = true;

                    # User owning the Homebrew prefix
                    user = username;

                    # Automatically migrate existing Homebrew installations
                    autoMigrate = true;
                  };
                }
                {
                  # Nix設定
                  nix = {
                    settings = {
                      experimental-features = "nix-command flakes";
                      trusted-users = [ "@admin" ];
                    };
                    gc = {
                      automatic = true;
                      interval = {
                        Weekday = 0;
                        Hour = 2;
                        Minute = 0;
                      };
                      options = "--delete-older-than 30d";
                    };
                  };

                  # Primary user for system settings
                  system.primaryUser = username;

                  # Mac Settings
                  system.defaults = {
                    # dock = {
                    #   autohide = true;
                    #   orientation = "bottom";
                    #   show-recents = false;
                    # };
                    finder = {
                      AppleShowAllExtensions = true;
                      AppleShowAllFiles = true;
                      # ShowPathbar = true;
                      # ShowStatusBar = true;
                    };
                    NSGlobalDomain = {
                      AppleShowAllExtensions = true;
                      AppleShowAllFiles = true;
                    };
                  };

                  system.keyboard = {
                    enableKeyMapping = true;
                    remapCapsLockToControl = true;
                  };

                  # Finderを再起動して設定を反映
                  system.activationScripts.postActivation.text = ''
                    echo "Restarting Finder to apply settings..."
                    /usr/bin/killall Finder 2>/dev/null || true

                    # キーボード設定の反映を試みる（完全な反映には再起動が必要な場合があります）
                    echo "Applying keyboard settings..."
                    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
                  '';

                  # 全ユーザー対象のシステムパッケージ
                  # 基本的にhome-managerでインストール
                  environment.systemPackages = with nixpkgsFor.${system}; [
                    # git
                  ];

                  # Homebrewの管理
                  homebrew = {
                    enable = true;
                    user = username;

                    #onActivation = {
                    #  autoUpdate = true;
                    #  # ここの値でこのファイルに書いてないパッケージを消すこともできる
                    #  cleanup = "none";
                    #  upgrade = true;
                    #};

                    masApps = {
                      # "Xcode" = 497799835;
                      # "Slack" = 803453959;
                    };

                    brews = [
                      "sl"
                    ];

                    casks = [
                      "orbstack"
                      "1password"
                      "firefox"
                      "google-chrome"
                      "visual-studio-code"
                      "jetbrains-toolbox"
                    ];

                    # Homebrewのtap
                    taps = [
                      "mtgto/macskk"
                      # "homebrew/cask-fonts"
                      # "homebrew/services"
                    ];
                  };

                  # home-manager統合設定
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    backupFileExtension = "backup";
                    users.${username} = { pkgs, lib, ... }: {
                      imports = [ ./home.nix ];
                      
                      home.username = username;
                      home.homeDirectory = nixpkgs.lib.mkForce "/Users/${username}";
                      home.stateVersion = "25.05";

                      # パッケージの定義（mkAfterで既存のパッケージに追加）
                      home.packages = 
                        (with nixpkgsFor.${system}; [
                          _1password-cli
                          awscli2
                          curl
                          devcontainer
                          gh
                          ghq
                          git
                          nodejs
                          git
                          tmux
                          lsd
                          fzf
                          fzf-zsh
                          silicon
                          direnv
                          python3
                          pyright
                          ruff
                          clang-tools
                          gopls
                          ripgrep
                          nodejs
                          gnupg
                          claude-code
                          tree
                          jq
                          uv
                          go
                          sqldef
                          imgcat  # iTerm2での画像表示用
                        ])
                        ++ [
                          nil.packages.${system}.nil
                          nixpkgs-ruby.packages.${system}."ruby-3.4"
                        ];

                      # プログラムの設定
                      programs.home-manager.enable = true;
                      programs = {
                        direnv = {
                          enable = true;
                          enableBashIntegration = true;
                          enableZshIntegration = true;
                          enableFishIntegration = true;
                          nix-direnv.enable = true;
                        };
                        bash.enable = true;
                      };
                    };
                  };
                  programs.bash.enable = true;
                  programs.zsh.enable = true;
                  programs.fish.enable = true;

                  # home-manager実行前のメッセージ表示
                  # extraActivationは標準のactivation sequenceの一部として実行される
                  system.activationScripts.extraActivation.text = ''
                    echo ""
                    echo "インストール後にコマンドがみつからない場合、新にターミナルをたちあげてください。"
                    echo "もし以下のようなエラーメッセージが表示された場合："
                    echo "対象ファイルがsymlinkが原因であるためと考えられます。対象を確認し、削除、リネームなどを行ってください。"
                    echo ""
                    echo "  Please do one of the following:"
                    echo "  - Move or remove the files below and try again."
                    echo "  - In standalone mode, use 'home-manager switch -b backup' to back up"
                    echo "    files automatically."
                    echo "  - When used as a NixOS or nix-darwin module, set"
                    echo "      'home-manager.backupFileExtension'"
                    echo "    to, for example, 'backup' and rebuild."
                    echo "  Existing file [file or blank] would be clobbered by backing up '/Users/[username]/[file]'";
                    echo "";
                  '';

                  # システムバージョン
                  system.stateVersion = 6;
                }
              ];
            };
        in
        {
          studistDarwin = mkDarwinConfig builtins.currentSystem;
        };

      # standalone版のhome-manager設定（現在は使用していません）
      # nix-darwinに統合されているため、以下の設定はコメントアウトされています
      # もしstandalone版を使用する場合は、コメントを解除してください
      #
      # homeConfigurations =
      #   let
      #     # 共通の設定を関数として定義
      #     mkHomeConfig =
      #       system:
      #       home-manager.lib.homeManagerConfiguration {
      #         pkgs = nixpkgsFor.${system};
      #         extraSpecialArgs = {
      #           inherit inputs;
      #         };
      #         modules = [
      #           {
      #             home.username = username;
      #             home.homeDirectory = "/Users/${username}";
      #             home.stateVersion = "25.05";
      #
      #             # パッケージの直接定義
      #             home.packages =
      #               (with nixpkgsFor.${system}; [
      #                 git
      #                 curl
      #                 devcontainer
      #                 gh
      #                 _1password-cli
      #
      #                 # こういうライブラリ群も管理できるが各個別レポジトリに管理させたい
      #                 # # 開発ツール（Ruby/Rails, TypeScript, Python用）
      #                 # gnumake # GNU Make - ネイティブ拡張のビルドに必要
      #                 # cmake # CMake - 一部のパッケージビルドに必要
      #                 # clang # Clang - C/C++コンパイラ
      #                 # gcc # GCC - GNU Compiler Collection
      #                 # pkg-config # コンパイル時の依存関係解決
      #                 #
      #                 # # ライブラリ（gemやnpmパッケージのビルド用）
      #                 # libxml2 # nokogiriなどXMLパーサー用
      #                 # libxslt # XSLTサポート
      #                 # libiconv # 文字エンコーディング変換
      #                 # zlib # 圧縮ライブラリ
      #                 # openssl # 暗号化ライブラリ
      #                 # postgresql # pgのビルド用
      #                 # mysql80 # mysql2のビルド用
      #                 # sqlite # sqlite3のビルド用
      #               ])
      #               ++ [
      #                 nil.packages.${system}.nil
      #                 # # レポジトリの状態を固定しているので常に同じ1psswordがインストールされる
      #                 # nixpkgs1passwordFor.${system}._1password
      #               ];
      #
      #             # # 開発環境用の環境変数設定
      #             # home.sessionVariables = {
      #             #   # Nixのライブラリを優先的に使用
      #             #   PKG_CONFIG_PATH = "${nixpkgsFor.${system}.pkg-config}/lib/pkgconfig:$PKG_CONFIG_PATH";
      #             #   LIBRARY_PATH = "${nixpkgsFor.${system}.zlib}/lib:${nixpkgsFor.${system}.openssl}/lib:$LIBRARY_PATH";
      #             #   CPATH = "${nixpkgsFor.${system}.zlib.dev}/include:${
      #             #     nixpkgsFor.${system}.openssl.dev
      #             #   }/include:$CPATH";
      #             # };
      #
      #             # プログラムの設定例
      #             programs.home-manager.enable = true;
      #
      #             programs = {
      #               direnv = {
      #                 enable = true;
      #                 enableBashIntegration = true;
      #                 enableZshIntegration = true;
      #                 enableFishIntegration = true;
      #                 nix-direnv.enable = true;
      #               };
      #
      #               bash.enable = true; # see note on other shells below
      #             };
      #             # programs.git = {
      #             #   enable = true;
      #             #   userName = "Your Name";
      #             #   userEmail = "your.email@example.com";
      #             # };
      #             #
      #             # programs.zsh = {
      #             #   enable = true;
      #             #   shellAliases = {
      #             #     ll = "ls -la";
      #             #     la = "ls -A";
      #             #   };
      #             # };
      #
      #           }
      #         ];
      #       };
      #   in
      #   {
      #     studistHomeConfig = mkHomeConfig builtins.currentSystem;
      #   };
    };
}
