{ config, lib, pkgs, ... }: {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.file.".config/k9s/skin.yml".source = ./.config/k9s/skin.yml;
  home.file.".gitconfig".source = ./gitconfig;

  home.packages = (import ./packages.nix) { inherit pkgs; };

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    PULUMI_K8S_SUPPRESS_HELM_HOOK_WARNINGS = "true";
  };

  home.stateVersion = "21.11";

  #---------------------------------------------------------------------
  # programs
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
          {
            index = 16;
            color = "0xff9e64";
          }
          {
            index = 17;
            color = "0xdb4b4b";
          }
        ];
      };

      cursor.style = "Block";

      font = { size = 12; };

      window = { opacity = 0.85; };
    };
  };

  programs.bat.enable = true;
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
      vimPlugins.nvim-lspconfig
      vimPlugins.lsp_extensions-nvim
      customVim.vim-just
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
      customVim.cmp-tabnine
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
      vimPlugins.lsp-colors-nvim
      vimPlugins.lsp_lines-nvim
      vimPlugins.lualine-nvim
      vimPlugins.nerdcommenter
      vimPlugins.nvim-treesitter-context
      vimPlugins.nvim-web-devicons
    ];
    extraConfig = (import ./.config/nvim) { inherit lib; };
  };

  programs.nnn.enable = true;

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [ customTmux.tokyonight ];
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
      cat = "bat --paging=never --theme='base16'";
      fetch = "git fetch --all --jobs=4 --progress --prune";
      ll = "n -Hde";
      pull = "git pull --autostash --ff --no-rebase --squash --summary origin";
      rebase = "git rebase --autostash --merge --stat";
      ssh = "TERM='xterm-256color' ssh";
      update = "fetch && rebase";
      woof = "k9s";
    };

    plugins = [{
      name = "zsh-z";
      src = pkgs.fetchFromGitHub {
        owner = "agkozak";
        repo = "zsh-z";
        rev = "aaafebcd97424c570ee247e2aeb3da30444299cd";
        sha256 = "sha256-9Wr4uZLk2CvINJilg4o72x0NEAl043lP30D3YnHk+ZA=";
      };
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
