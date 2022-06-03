{ config, lib, pkgs, ... }:

let 
  sources = import ../../nix/sources.nix;
in {
  imports = [
    ../shared/home-manager.nix
  ];
  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  home.packages = [
    # programs
    pkgs.ansible
    pkgs.awscli2
    pkgs.bat
    pkgs.bottom
    pkgs.firefox-bin
    pkgs.gcc
    pkgs.k9s
    pkgs.kind
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.nnn
    pkgs.jetbrains.jdk
    pkgs.jetbrains.datagrip
    pkgs.slack

    # language servers
    pkgs.nodePackages."bash-language-server"
    pkgs.nodePackages."vscode-langservers-extracted"
    pkgs.nodePackages."dockerfile-language-server-nodejs"
    pkgs.elixir_ls
    pkgs.gopls
    pkgs.python3Packages."python-lsp-server"
    pkgs.rust-analyzer
    pkgs.sumneko-lua-language-server
    pkgs.terraform-lsp
    pkgs.nodePackages."typescript"
    pkgs.nodePackages."typescript-language-server"
    pkgs.nodePackages."yaml-language-server"
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };
}
