{ inputs }:

{ pkgs, ... }:

let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
  jsonnet = import ./jsonnet.nix { inherit pkgs; };
  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "10de9ebf0bd8df8ff8593b0b87ec8bf3b715326f";
      sha256 = "sha256-NGhWF4/SEPww9e/wCDghGMSPZmmAbms6tn/IHqDMDkI=";
    };
  };
  zsh-z = pkgs.fetchFromGitHub {
    owner = "agkozak";
    repo = "zsh-z";
    rev = "da8dee3ccaf882d1bf653c34850041025616ceb5";
    sha256 = "sha256-MHb9Q7mwgWAs99vom6a2aODB40I9JTBaJnbvTYbMwiA=";
  };
in
{
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/nvim/after/ftplugin/markdown.vim".text = ''
    setlocal wrap
  '';

  home.sessionVariables = {
    CHARM_HOST = "localhost";
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
      catppuccin = builtins.readFile
        (catppuccin-bat + "/Catppuccin-macchiato.tmTheme");
    };
  };

  programs.bottom.enable = true;

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.git = {
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
    userEmail = "4638629+erikreinert@users.noreply.github.com";
    userName = "Erik Reinert";

    extraConfig = {
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      github.user = "erikreinert";
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      foreground = "#CAD3F5";
      background = "#24273A";
      selection_foreground = "#24273A";
      selection_background = "#F4DBD6";
      cursor = "#F4DBD6";
      cursor_text_color = "#24273A";
      url_color = "#F4DBD6";
      active_border_color = "#B7BDF8";
      inactive_border_color = "#6E738D";
      bell_border_color = "#EED49F";
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";
      active_tab_foreground = "#181926";
      active_tab_background = "#C6A0F6";
      inactive_tab_foreground = "#CAD3F5";
      inactive_tab_background = "#1E2030";
      tab_bar_background = "#181926";
      mark1_foreground = "#24273A";
      mark1_background = "#B7BDF8";
      mark2_foreground = "#24273A";
      mark2_background = "#C6A0F6";
      mark3_foreground = "#24273A";
      mark3_background = "#7DC4E4";
      color0 = "#494D64";
      color8 = "#5B6078";
      color1 = "#ED8796";
      color9 = "#ED8796";
      color2 = "#A6DA95";
      color10 = "#A6DA95";
      color3 = "#EED49F";
      color11 = "#EED49F";
      color4 = "#8AADF4";
      color12 = "#8AADF4";
      color5 = "#F5BDE6";
      color13 = "#F5BDE6";
      color6 = "#8BD5CA";
      color14 = "#8BD5CA";
      color7 = "#B8C0E0";
      color15 = "#A5ADCB";
      background_opacity = "0.9";
      font_size = "15";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      enabled_layouts = "splits";
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

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.catppuccin-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      (vimPlugins.ChatGPT-nvim.overrideAttrs (old: {
        src = fetchFromGitHub {
          owner = "jackMort";
          repo = "ChatGPT.nvim";
          rev = "f499559f636676498692a2f19e74b077cbf52839";
          sha256 = "sha256-98daaRkdrTZyNZuQPciaeRNuzyS52bsha4yyyAALcog=";
        };
      }))
      vimPlugins.copilot-lua
      vimPlugins.gitsigns-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.noice-nvim
      vimPlugins.nui-nvim
      vimPlugins.nvim-colorizer-lua
      vimPlugins.nvim-notify
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-ts-rainbow2
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
      jsonnet
      nodejs
      python310Full
      rustc

      # language servers
      gopls
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
      rust-analyzer
      terraform-ls

      # formatters
      gofumpt
      golines
      nixpkgs-fmt
      python310Packages.black
      rustfmt

      # tools
      cargo
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
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "18b5371d08e341ddefd2d023e3f7d201cac22b89";
        sha256 = "sha256-L6p7bd5XXOHBZWei21czHC0N0Ne1k2YMuc6QhVdSxcQ=";
      }) + "/plugins";
    };
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
    '';
    plugins = with pkgs; [ customTmux.catppuccin ];
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = if isDarwin then "screen-256color" else "xterm-256color";
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      ll = if isDarwin then "n" else "n -P K";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
    };

    plugins = [{
      name = "zsh-z";
      src = zsh-z;
    }];

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
  };
}
