{inputs}: {
  git,
  homeDirectory,
  username,
}: {pkgs, ...}: let
  delta = inputs.nixpkgs-stable.legacyPackages.${system}.delta;
  direnv = inputs.nixpkgs-stable.legacyPackages.${system}.direnv;
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  system = pkgs.system;
in {
  #---------------------------------------------------------------------
  # home
  #---------------------------------------------------------------------

  home.homeDirectory = homeDirectory;

  home.packages = with pkgs; [
    httpie
    nixVersions.latest
  ];

  home.stateVersion = "25.05";

  home.username = username;

  #---------------------------------------------------------------------
  # programs
  #---------------------------------------------------------------------

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
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

    package = delta;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    package = direnv;
    nix-direnv = {
      enable = true;
    };
  };

  programs.git =
    pkgs.lib.recursiveUpdate git
    {
      enable = true;

      settings = {
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
        pagers = [
          {
            colorArg = "always";
            pager = "delta --color-only --dark --paging=never";
            useConfig = false;
          }
        ];
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

    initContent = ''
      c () {
        emulate -L zsh

        # Scope = <repo>/<worktree> if inside a .git worktree path, else the current dir
        local dir="$PWD" scope
        if [[ "$dir" == *.git/* ]]; then
          local repo="''${dir%%.git/*}"; repo="''${repo:t}"
          local worktree="''${dir#*.git/}"
          scope="$repo/$worktree"
        else
          scope="''${dir:t}"
        fi

        # Name (required)
        local name
        while true; do
          name=$(gum input --prompt "session name: " --placeholder "e.g. workshop-docs") || return 1
          [[ -n "$name" ]] && break
          gum style --foreground 1 "A name is required."
        done

        # Task prompt (optional)
        local task
        task=$(gum write --placeholder "Optional task for Claude - Ctrl+D to dispatch, Esc to skip") || task=""

        local session="$scope#$name"
        local -a args=(--bg --name "$session")

        if [[ -n "$task" ]]; then
          claude "''${args[@]}" "$task"
        else
          claude "''${args[@]}"
        fi
      }

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
      - role: worker
      - role: worker
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

      source $HOME/.vorpal/bin/vorpal-activate-shell
      eval "$(zoxide init zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };

    shellAliases = {
      cat = "bat";
      dk = "docket";
      lg = "lazygit";
      ll =
        if isDarwin
        then "n"
        else "n -P K";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
    };

    syntaxHighlighting = {
      enable = true;
    };
  };
}
