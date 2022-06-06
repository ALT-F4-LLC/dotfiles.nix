{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  i3_mod = "Mod4";
in {
  #---------------------------------------------------------------------
  # Files
  #---------------------------------------------------------------------

  home.file.".background-image".source = ./background-image;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.alacritty = {
    enable = true;

    settings = {
      colors = {
        primary = {
          background = "0x24283b";
          foreground = "0xc0caf5";
        };

        normal = {
          black = "0x1D202F";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xa9b1d6";
        };

        bright = {
          black = "0x414868";
          red = "0xf7768e";
          green = "0x9ece6a";
          yellow = "0xe0af68";
          blue = "0x7aa2f7";
          magenta = "0xbb9af7";
          cyan = "0x7dcfff";
          white = "0xc0caf5";
        };

        indexed_colors = [
          { index = 16; color = "0xff9e64"; }
          { index = 17; color = "0xdb4b4b"; }
        ];
      };

      cursor.style = "Block";

      window = {
        opacity = 0.80;
      };
    };
  };

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.git = {
    enable = true;
    userName  = "Erik Reinert";
    userEmail = "erik@altf4.email";
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      diff.colorMoved = "zebra";
      fetch.prune = true;
      github.user = "erikreinert";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.default = "tracking";
      rebase.autoStash = true;
    };
  };

  programs.gpg.enable = true;

  programs.i3status = {
    enable = true;

    general = {
      colors = true;
      color_good = "#c0caf5";
      color_bad = "#f7768e";
      color_degraded = "#ff9e64";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    plugins = with pkgs; [
      # languages
      vimPlugins.nvim-lspconfig
      vimPlugins.lsp_extensions-nvim
      customVim.lspcontainers-nvim
      vimPlugins.vim-nix
      vimPlugins.vim-prisma
      vimPlugins.vim-terraform

      # treesitter
      vimPlugins.nvim-treesitter

      # completion
      vimPlugins.nvim-cmp
      vimPlugins.lspkind-nvim
      vimPlugins.cmp-buffer
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-path
      vimPlugins.cmp-tabnine
      vimPlugins.cmp-treesitter
      vimPlugins.cmp-vsnip
      vimPlugins.vim-vsnip

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim

      # theme
      vimPlugins.tokyonight-nvim

      # floaterm
      vimPlugins.vim-floaterm

      # extras
      vimPlugins.gitsigns-nvim
      vimPlugins.indent-blankline-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-web-devicons
      vimPlugins.trouble-nvim
      vimPlugins.lsp-colors-nvim
      vimPlugins.vim-hardtime
    ];
    extraConfig = (import ../shared/nvim) { inherit lib; };
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat --paging=never --theme='base16'";
      ll = "n -Hde";
      ssh = "TERM='xterm-256color' ssh";
      rebase = "git fetch --all --prune --prune-tags && git rebase";
      woof = "k9s";
      nixos_switch = "sudo nixos-rebuild switch --flake '/nix-config#vm-intel'";
      nixos_test = "sudo nixos-rebuild test --flake '/nix-config#vm-intel'";
    };

    plugins = map (n: {
      name = n;
      src  = sources.${n};
    }) [
      "zsh-autosuggestions"
      "zsh-completions"
      "zsh-syntax-highlighting"
      "zsh-z"
    ];

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

  #---------------------------------------------------------------------
  # services
  #---------------------------------------------------------------------

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  #---------------------------------------------------------------------
  # xsession
  #---------------------------------------------------------------------

  xsession.windowManager.i3 = {
    enable = true;

    config = {
      bars = [
        {
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          colors = {
            background = "#1a1b26";
            statusline = "#c0caf5";
            separator = "#3b4261";
            focusedWorkspace = {
              background = "#c0caf5";
              border = "#3b4261";
              text = "#565f89";
            };
            activeWorkspace = {
              background = "#353836";
              border = "#595B5B";
              text = "#FDF6E3";
            };
            inactiveWorkspace = {
              background = "#222D31";
              border = "#595B5B";
              text = "#EEE8D5";
            };
            bindingMode = {
              background = "#2C2C2C";
              border = "#16a085";
              text = "#F9FAF9";
            };
            urgentWorkspace = {
              background = "#FDF6E3";
              border = "#16a085";
              text = "#E5201D";
            };
          };
        }
      ];

      fonts = {
        names = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
      };

      gaps = {
        inner = 0;
        outer = 0;
      };

      keybindings = {
        "${i3_mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${i3_mod}+Shift+q" = "kill";

        "${i3_mod}+d" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -modi drun -show drun";

        "${i3_mod}+Left" = "focus left";
        "${i3_mod}+Down" = "focus down";
        "${i3_mod}+Up" = "focus up";
        "${i3_mod}+Right" = "focus right";

        "${i3_mod}+Shift+Left" = "move left";
        "${i3_mod}+Shift+Down" = "move down";
        "${i3_mod}+Shift+Up" = "move up";
        "${i3_mod}+Shift+Right" = "move right";

        "${i3_mod}+h" = "split h; exec notify-send 'Tile Horizontally'";
        "${i3_mod}+v" = "split v; exec notify-send 'Tile Vertically'";
        "${i3_mod}+f" = "fullscreen toggle";

        "${i3_mod}+s" = "layout stacking";
        "${i3_mod}+w" = "layout tabbed";
        "${i3_mod}+e" = "layout toggle split";

        "${i3_mod}+Shift+space" = "floating toggle";
        "${i3_mod}+space" = "focus mode_toggle";

        "${i3_mod}+a" = "focus parent";

        "${i3_mod}+Shift+minus" = "move scratchpad";
        "${i3_mod}+minus" = "scratchpad show";

        "${i3_mod}+1" = "workspace number 1";
        "${i3_mod}+2" = "workspace number 2";
        "${i3_mod}+3" = "workspace number 3";
        "${i3_mod}+4" = "workspace number 4";
        "${i3_mod}+5" = "workspace number 5";
        "${i3_mod}+6" = "workspace number 6";
        "${i3_mod}+7" = "workspace number 7";
        "${i3_mod}+8" = "workspace number 8";
        "${i3_mod}+9" = "workspace number 9";
        "${i3_mod}+0" = "workspace number 10";

        "${i3_mod}+Shift+1" = "move container to workspace number 1";
        "${i3_mod}+Shift+2" = "move container to workspace number 2";
        "${i3_mod}+Shift+3" = "move container to workspace number 3";
        "${i3_mod}+Shift+4" = "move container to workspace number 4";
        "${i3_mod}+Shift+5" = "move container to workspace number 5";
        "${i3_mod}+Shift+6" = "move container to workspace number 6";
        "${i3_mod}+Shift+7" = "move container to workspace number 7";
        "${i3_mod}+Shift+8" = "move container to workspace number 8";
        "${i3_mod}+Shift+9" = "move container to workspace number 9";
        "${i3_mod}+Shift+0" = "move container to workspace number 10";

        "${i3_mod}+Shift+c" = "reload";
        "${i3_mod}+Shift+r" = "restart";
        "${i3_mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${i3_mod}+r" = "mode resize";
      };

      modifier = i3_mod;

      window = {
        border = 0;
        hideEdgeBorders = "none";
      };
    };

    extraConfig = ''
      default_border none
      default_floating_border none
      smart_borders on
      smart_gaps on
    '';
  };
}
