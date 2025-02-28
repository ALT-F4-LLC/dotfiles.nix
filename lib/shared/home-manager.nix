{inputs}: {
  git,
  homeDirectory,
  username,
}: {pkgs, ...}: let
  awscli2 = inputs.nixpkgs-stable.legacyPackages.${system}.awscli2;
  delta = inputs.nixpkgs-stable.legacyPackages.${system}.delta;
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
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
    background-opacity = 0.95
    font-family = GeistMono NFM
    font-size = 18
    macos-option-as-alt = true
    theme = TokyoNight
  '';

  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    awscli2
    doppler
    fd
    gh
    httpie
    jq
    k9s
    kubectl
    nixVersions.latest
    ripgrep
    shell-gpt
    z-lua
  ];

  home.sessionVariables = {
    DEFAULT_MODEL = "gpt-4o";
    EDITOR = "nvim";
  };

  home.stateVersion = "24.11";

  home.username = username;

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.bat = {
    enable = true;
    config = {theme = "tokyonight";};
    themes = {
      tokyonight = {
        src =
          pkgs.fetchFromGitHub
          {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "b262293ef481b0d1f7a14c708ea7ca649672e200";
            sha256 = "sha256-pMzk1gRQFA76BCnIEGBRjJ0bQ4YOf3qecaU6Fl/nqLE=";
          };
        file = "extras/sublime/tokyonight_night.tmTheme";
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
        package = delta;
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
        core.editor = "nvim";
        diff.colorMoved = "zebra";
        fetch.prune = true;
        init.defaultBranch = "main";
        merge.conflictstyle = "diff3";
        push.autoSetupRemote = true;
        rebase.autoStash = true;
      };

      lfs.enable = true;
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
      mappings.K = "preview-tui";
      src = pkgs.nnn + "/plugins";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      character = {
        error_symbol = "[➜](bold red)";
        success_symbol = "[➜](bold green)";
      };
    };
  };

  programs.zsh = {
    autosuggestion.enable = true;
    enable = true;
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
      cpm = ''git diff --staged | s -- sgpt --code --no-cache "Generate a git commit message describing the changes using the conventional commit specifiction (DO NOT GENERATE A COMMAND)" | git commit -F -'';
      cpr = ''git diff $(git merge-base $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5) $(git branch --show-current))..HEAD | s -- sgpt --code --no-cache "Generate a 30 character max GitHub Pull Request title and description that includes only categorized lists (added, removed, etc) using symver specification in markdown. Do not include git diff output."'';
      dr = "docker container run --interactive --rm --tty";
      lg = "lazygit";
      ll =
        if isDarwin
        then "n"
        else "n -P K";
      nb = "nix build --json --no-link --print-build-logs";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      sgpt = "s -- sgpt --no-cache";
      wt = "git worktree";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
