{ config, lib, pkgs, ... }:
let sources = import ../nix/sources.nix;
in {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file = {
    ".gitconfig" = {
      source = ./gitconfig;
      target = ".gitconfig";
    };
  };

  home.packages = (import ./packages.nix) { inherit pkgs; };

  home.sessionVariables = {
    CHARM_HOST = "localhost";
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PULUMI_K8S_SUPPRESS_HELM_HOOK_WARNINGS = "true";
    PULUMI_SKIP_UPDATE_CHECK = "true";
  };

  home.stateVersion = "22.05";

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = { theme = "catppuccin"; };
    themes = {
      catppuccin = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "00bd462e8fab5f74490335dcf881ebe7784d23fa";
        sha256 = "sha256-yzn+1IXxQaKcCK7fBdjtVohns0kbN+gcqbWVE4Bx7G8=";
      } + "/Catppuccin-macchiato.tmTheme");
    };
  };

  programs.bottom.enable = true;

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.git = {
    delta = { enable = true; };

    enable = true;
    userEmail = "erik@altf4.email";
    userName = "Erik Reinert";

    extraConfig = {
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      github.user = "erikreinert";
      init.defaultBranch = "main";
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
      font_size = "12.0";
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
    package = pkgs.neovim-nightly;

    plugins = with pkgs; [
      # languages
      customVim.earthly-vim
      customVim.vim-just
      vimPlugins.nvim-lspconfig
      vimPlugins.vim-nix
      vimPlugins.vim-prisma
      vimPlugins.vim-terraform

      # treesitter
      vimPlugins.nvim-treesitter

      # completion
      customVim.cmp-tabnine
      vimPlugins.cmp-buffer
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-path
      vimPlugins.cmp-treesitter
      vimPlugins.cmp-vsnip
      vimPlugins.lspkind-nvim
      vimPlugins.nvim-cmp
      vimPlugins.vim-vsnip

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.catppuccin-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      customVim.gitsigns-nvim
      customVim.lsp_lines-nvim
      vimPlugins.indent-blankline-nvim
      vimPlugins.lsp-colors-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-web-devicons

      # configuration
      customVim.thealtf4stream
    ];

    extraConfig = ''
      lua << EOF
        require 'TheAltF4Stream'.init()
      EOF
    '';
  };

  programs.nnn.enable = true;

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"
    '';
    plugins = with pkgs; [ customTmux.catppuccin ];
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
      fetch = "git fetch --all --jobs=4 --progress --prune";
      ll = "n -Hde";
      pull = "git pull --autostash --jobs=4 --summary origin";
      rebase = "git rebase --autostash --stat";
      ssh = "TERM='xterm-256color' ssh";
      update = "fetch && rebase";
      woof = "k9s";
      wt = "git worktree";
    };

    plugins = [{
      name = "zsh-z";
      src = sources.zsh-z;
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
          hostPort: 80
          protocol: TCP
        - containerPort: 443
          hostPort: 443
          protocol: TCP
      EOF
      }

      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }
    '';
  };
}
