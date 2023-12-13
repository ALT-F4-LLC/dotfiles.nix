{ inputs }: { git }: { pkgs, ... }:

let
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    nativeBuildInputs = with pkgs; [ pkg-config readline ];
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "3451e22daade268f99b1cfeb0d9fe39f4ddc06d5";
      sha256 = "sha256-2pzdtMGdmCTprkPslGdlEezdQ6dTFrhqvz5Sc8DN3Ts=";
    };
  };
in
{
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/nvim/after/ftplugin/markdown.vim".text = ''
    setlocal wrap
  '';

  home.packages = with pkgs; [
    awscli2
    doppler
    gh
    jq
    k9s
    kubectl
    ripgrep
    z-lua
  ];

  home.sessionVariables = {
    CHARM_HOST = "localhost";
    DOTNET_CLI_TELEMETRY_OPTOUT = "true";
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
    PULUMI_K8S_SUPPRESS_HELM_HOOK_WARNINGS = "true";
    PULUMI_SKIP_UPDATE_CHECK = "true";
  };

  home.stateVersion = "23.05";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = { theme = "catppuccin"; };
    themes = {
      catppuccin = {
        src = pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
        file = "Catppuccin-macchiato.tmTheme";
      };
    };
  };

  programs.bottom.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = pkgs.lib.recursiveUpdate git
    {
      delta = {
        enable = true;
        options = {
          chameleon = {
            dark = true;
            line-numbers = true;
            side-by-side = true;
            keep-plus-minus-markers = true;
            syntax-theme = "Nord";
            file-style = "#434C5E bold";
            file-decoration-style = "#434C5E ul";
            file-added-label = "[+]";
            file-copied-label = "[==]";
            file-modified-label = "[*]";
            file-removed-label = "[-]";
            file-renamed-label = "[->]";
            hunk-header-style = "omit";
            line-numbers-left-format = " {nm:>1} │";
            line-numbers-left-style = "red";
            line-numbers-right-format = " {np:>1} │";
            line-numbers-right-style = "green";
            line-numbers-minus-style = "red italic black";
            line-numbers-plus-style = "green italic black";
            line-numbers-zero-style = "#434C5E italic";
            minus-style = "bold red";
            minus-emph-style = "bold red";
            plus-style = "bold green";
            plus-emph-style = "bold green";
            zero-style = "syntax";
            blame-code-style = "syntax";
            blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
            blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
          };
          features = "chameleon";
          side-by-side = true;
        };
      };

      enable = true;

      extraConfig = {
        color.ui = true;
        commit.gpgsign = true;
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };
    };

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Geist Mono";
      package = inputs.self.packages.${pkgs.system}.geist-mono;
      size = if isDarwin then 20 else 15;
    };
    settings = {
      active_border_color = "#B7BDF8";
      active_tab_background = "#C6A0F6";
      active_tab_foreground = "#181926";
      allow_remote_control = "yes";
      background = "#24273A";
      background_opacity = "0.9";
      bell_border_color = "#EED49F";
      color0 = "#494D64";
      color1 = "#ED8796";
      color10 = "#A6DA95";
      color11 = "#EED49F";
      color12 = "#8AADF4";
      color13 = "#F5BDE6";
      color14 = "#8BD5CA";
      color15 = "#A5ADCB";
      color2 = "#A6DA95";
      color3 = "#EED49F";
      color4 = "#8AADF4";
      color5 = "#F5BDE6";
      color6 = "#8BD5CA";
      color7 = "#B8C0E0";
      color8 = "#5B6078";
      color9 = "#ED8796";
      cursor = "#F4DBD6";
      cursor_text_color = "#24273A";
      enabled_layouts = "splits";
      foreground = "#CAD3F5";
      hide_window_decorations = "titlebar-and-corners";
      inactive_border_color = "#6E738D";
      inactive_tab_background = "#1E2030";
      inactive_tab_foreground = "#CAD3F5";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "background";
      mark1_background = "#B7BDF8";
      mark1_foreground = "#24273A";
      mark2_background = "#C6A0F6";
      mark2_foreground = "#24273A";
      mark3_background = "#7DC4E4";
      mark3_foreground = "#24273A";
      selection_background = "#F4DBD6";
      selection_foreground = "#24273A";
      tab_bar_background = "#181926";
      url_color = "#F4DBD6";
      wayland_titlebar_color = "system";
    };
    theme = "Catppuccin-Macchiato";
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --color-only --dark --paging=never";
          useConfig = false;
        };
      };
    };
  };

  programs.neovim = {
    enable = true;

    plugins = with pkgs; [
      # languages
      vim-just
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.rust-tools-nvim
      vimPlugins.vim-cue

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.catppuccin-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      vimPlugins.ChatGPT-nvim
      vimPlugins.copilot-lua
      vimPlugins.gitsigns-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.nui-nvim
      vimPlugins.nvim-colorizer-lua
      vimPlugins.nvim-notify
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-ts-rainbow2
      vimPlugins.omnisharp-extended-lsp-nvim
      #vimPlugins.nvim-web-devicons # https://github.com/intel/intel-one-mono/issues/9

      # configuration
      inputs.self.packages.${pkgs.system}.thealtf4stream-nvim
    ];

    extraConfig = ''
      lua << EOF
        require 'TheAltF4Stream'.init()
      EOF
    '';

    extraPackages = with pkgs; [
      # languages
      dotnet-sdk_8
      jsonnet
      nodejs
      python310Full
      rustc

      # language servers
      cuelsp
      haskell-language-server
      jsonnet-language-server
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      nodePackages."pyright"
      nodePackages."typescript"
      nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
      omnisharp-roslyn
      gopls
      rust-analyzer
      terraform-ls

      # formatters
      nixpkgs-fmt
      gofumpt
      golines
      python310Packages.black
      rustfmt
      terraform

      # tools
      cargo
      fd
      gcc
      ghc
      lazydocker
      yarn
    ];
  };

  programs.nnn = {
    enable = true;
    #package = pkgs.nnn.override ({ withNerdIcons = true; }); # https://github.com/intel/intel-one-mono/issues/9
    plugins = {
      mappings = {
        K = "preview-tui";
      };
      src = pkgs.nnn + "/plugins";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
    '';
    plugins = with pkgs; [ tmuxPlugins.catppuccin ];
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = if isDarwin then "screen-256color" else "xterm-256color";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtra = ''
      kindc () {
        cat <<EOF | kind create cluster --config=-
      kind: Cluster
      apiVersion: kind.x-k8s.io/v1alpha4
      nodes:
      - role: control-plane
        kubeadmConfigPatches:
        - |
          kind: InitConfiguration
          nodeRegistration:
            kubeletExtraArgs:
              node-labels: "ingress-ready=true"
        extraPortMappings:
        - containerPort: 80
          hostPort: 8080
          protocol: TCP
        - containerPort: 443
          hostPort: 8443
          protocol: TCP
      EOF
      }
      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn -adeHo "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      lg = "lazygit";
      ll = if isDarwin then "n" else "n -P K";
      nb = "nix build --json --no-link --print-build-logs";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
