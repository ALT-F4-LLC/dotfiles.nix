{ pkgs, extras, ... }:
[
  # programs
  pkgs.ansible
  pkgs.awscli2
  pkgs.azure-cli
  pkgs.bat
  pkgs.bottom
  pkgs.delta
  pkgs.doppler
  pkgs.firefox-bin
  pkgs.gcc
  pkgs.git-secret
  pkgs.httpie
  pkgs.jetbrains.datagrip
  pkgs.jetbrains.jdk
  pkgs.k9s
  pkgs.kind
  pkgs.kn
  pkgs.kubectl
  pkgs.lazydocker
  pkgs.lazygit
  pkgs.nnn
  pkgs.nodejs-16_x
  pkgs.postman
  pkgs.python3Full
  pkgs.redli
  pkgs.ripgrep
  pkgs.terraform
  pkgs.vscode

  # language servers
  pkgs.elixir_ls
  pkgs.gopls
  pkgs.nodePackages."@prisma/language-server"
  pkgs.nodePackages."bash-language-server"
  pkgs.nodePackages."dockerfile-language-server-nodejs"
  pkgs.nodePackages."graphql-language-service-cli"
  pkgs.nodePackages."typescript"
  pkgs.nodePackages."typescript-language-server"
  pkgs.nodePackages."vscode-langservers-extracted"
  pkgs.nodePackages."yaml-language-server"
  pkgs.python3Packages."python-lsp-server"
  pkgs.rust-analyzer
  pkgs.sumneko-lua-language-server
  pkgs.terraform-ls
  pkgs.customVim.jsonnet-language-server
] ++ extras
