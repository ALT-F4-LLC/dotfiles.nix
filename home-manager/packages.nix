{ pkgs, ... }:

with pkgs; [
  # programs
  ansible
  awscli2
  azure-cli
  cargo
  dogdns
  doppler
  gcc
  httpie
  jetbrains.datagrip
  jq
  just
  k9s
  kind
  kn
  kubectl
  lazydocker
  nodejs-16_x
  poetry
  postman
  pulumi-bin
  python3Full
  ripgrep
  rustc
  rustfmt
  terraform
  yarn

  # language servers
  elixir_ls
  gopls
  nodePackages."@prisma/language-server"
  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  python3Packages."python-lsp-server"
  rust-analyzer
  sumneko-lua-language-server
  terraform-ls
  customVim.jsonnet-language-server
]
