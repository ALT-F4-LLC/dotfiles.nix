{inputs}: {git}: {pkgs, ...}: let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  isLinux = system == "aarch64-linux" || system == "x86_64-linux";
  system = pkgs.system;
in {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/nvim/after/ftplugin/markdown.vim".text = ''
    setlocal wrap
  '';

  home.file.".config/ghostty/config".text = ''
    # settings
    background = 161616
    background-opacity = 0.9
    cursor-color = f2f4f8
    font-family = "GeistMono NFM"
    font-size = 18
    foreground = dde1e6
    macos-option-as-alt = true
    selection-background = 525252
    selection-foreground = f2f4f8

    # theme
    palette = 0=#262626
    palette = 1=#ff7eb6
    palette = 2=#42be65
    palette = 3=#82cfff
    palette = 4=#33b1ff
    palette = 5=#ee5396
    palette = 6=#3ddbd9
    palette = 7=#dde1e6
    palette = 8=#393939
    palette = 9=#ff7eb6
    palette = 10=#42be65
    palette = 11=#82cfff
    palette = 12=#33b1ff
    palette = 13=#ee5396
    palette = 14=#3ddbd9
    palette = 15=#ffffff
  '';

  home.packages = with pkgs;
    [
      awscli2
      cachix
      doppler
      fd
      gh
      git-remote-codecommit
      jq
      k9s
      kubectl
      lazydocker
      ripgrep
      z-lua
    ]
    ++ lib.lists.optionals isLinux [
      inputs.ghostty.packages.${pkgs.system}.default
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

  home.stateVersion = "23.11";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = {theme = "catppuccin";};
    themes = {
      catppuccin = {
        src =
          pkgs.fetchFromGitHub
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

  programs.git =
    pkgs.lib.recursiveUpdate git
    {
      delta = {
        enable = true;
        options = {
          chameleon = {
            blame-code-style = "syntax";
            blame-format = "{author:<18} ({commit:>7}) {timestamp:^12} ";
            blame-palette = "#2E3440 #3B4252 #434C5E #4C566A";
            dark = true;
            file-added-label = "[+]";
            file-copied-label = "[==]";
            file-decoration-style = "#434C5E ul";
            file-modified-label = "[*]";
            file-removed-label = "[-]";
            file-renamed-label = "[->]";
            file-style = "#434C5E bold";
            hunk-header-style = "omit";
            keep-plus-minus-markers = true;
            line-numbers = true;
            line-numbers-left-format = " {nm:>1} │";
            line-numbers-left-style = "red";
            line-numbers-minus-style = "red italic black";
            line-numbers-plus-style = "green italic black";
            line-numbers-right-format = " {np:>1} │";
            line-numbers-right-style = "green";
            line-numbers-zero-style = "#434C5E italic";
            minus-emph-style = "bold red";
            minus-style = "bold red";
            plus-emph-style = "bold green";
            plus-style = "bold green";
            side-by-side = true;
            syntax-theme = "Nord";
            zero-style = "syntax";
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
      name = "GeistMono";
      package = inputs.self.packages.${pkgs.system}.geist-mono;
      size =
        if isDarwin
        then 18
        else 15;
    };

    settings = {
      active_border_color = "#ee5396";
      active_tab_background = "#ee5396";
      active_tab_foreground = "#161616";
      allow_remote_control = "yes";
      background = "#161616";
      background_opacity = "0.9";
      bell_border_color = "#ee5396";
      color0 = "#262626";
      color1 = "#ff7eb6";
      color10 = "#42be65";
      color11 = "#82cfff";
      color12 = "#33b1ff";
      color13 = "#ee5396";
      color14 = "#3ddbd9";
      color15 = "#ffffff";
      color2 = "#42be65";
      color3 = "#82cfff";
      color4 = "#33b1ff";
      color5 = "#ee5396";
      color6 = "#3ddbd9";
      color7 = "#dde1e6";
      color8 = "#393939";
      color9 = "#ff7eb6";
      cursor = "#f2f4f8";
      cursor_text_color = "#393939";
      enabled_layouts = "splits";
      foreground = "#dde1e6";
      hide_window_decorations = "titlebar-and-corners";
      inactive_border_color = "#ff7eb6";
      inactive_tab_background = "#393939";
      inactive_tab_foreground = "#dde1e6";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "system";
      selection_background = "#525252";
      selection_foreground = "#f2f4f8";
      tab_bar_background = "#161616";
      url_color = "#ee5396";
      url_style = "single";
      wayland_titlebar_color = "system";
    };
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

  programs.neovim = inputs.thealtf4stream-nvim.lib.mkHomeManager {inherit system;};

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {withNerdIcons = true;};
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

      # Palette
      set -g status-style bg=colour8,fg=colour7
      setw -g window-status-style bg=default,fg=colour8
      setw -g window-status-current-style bg=colour8,fg=colour7
      setw -g pane-border-style fg=colour8
      setw -g pane-active-border-style fg=colour7

      # Basic colors
      set -g status-bg colour8
      set -g status-fg colour7

      # Set the default background and foreground colors
      set -g default-terminal "screen-256color"

      # More specific window status formatting
      setw -g window-status-format "#[fg=colour3,bg=default]#I #W"
      setw -g window-status-current-format "#[fg=colour2,bg=colour8]#I #W"

      # Message styling
      set -g message-style bg=colour0,fg=colour7
      set -g message-command-style bg=colour0,fg=colour7
    '';
    shell = "${pkgs.zsh}/bin/zsh";
    terminal =
      if isDarwin
      then "screen-256color"
      else "xterm-256color";
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
      plugins = ["git" "z"];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      dr = "docker container run --interactive --rm --tty";
      lg = "lazygit";
      ll =
        if isDarwin
        then "n"
        else "n -P K";
      nb = "nix build --json --no-link --print-build-logs";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
