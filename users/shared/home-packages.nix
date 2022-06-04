{ pkgs, extras, ... }:
[
  # programs
  pkgs.ansible
  pkgs.awscli2
  pkgs.bat
  pkgs.bottom
  pkgs.doppler
  pkgs.firefox-bin
  pkgs.gcc
  pkgs.git-secret
  pkgs.jetbrains.datagrip
  pkgs.jetbrains.jdk
  pkgs.k9s
  pkgs.kind
  pkgs.lazydocker
  pkgs.lazygit
  pkgs.newman
  pkgs.nnn
  pkgs.nodejs-16_x
  pkgs.postman
  pkgs.python3Full
  pkgs.ripgrep

  # language servers
  pkgs.elixir_ls
  pkgs.gopls
  pkgs.nodePackages."bash-language-server"
  pkgs.nodePackages."dockerfile-language-server-nodejs"
  pkgs.nodePackages."typescript"
  pkgs.nodePackages."typescript-language-server"
  pkgs.nodePackages."vscode-langservers-extracted"
  pkgs.nodePackages."yaml-language-server"
  pkgs.python3Packages."python-lsp-server"
  pkgs.rust-analyzer
  pkgs.sumneko-lua-language-server
  pkgs.terraform-lsp
] ++ extras
