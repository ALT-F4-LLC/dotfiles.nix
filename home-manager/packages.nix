{ pkgs, ... }:

with pkgs; [
  # programs
  ansible
  awscli2
  azure-cli
  cargo
  dogdns
  doppler
  fd
  gcc
  gnumake
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
  virtualenv
  yarn

  # language servers
  customVim.jsonnet-language-server
  elixir_ls
  gopls
  nodePackages."@prisma/language-server"
  nodePackages."bash-language-server"
  nodePackages."dockerfile-language-server-nodejs"
  nodePackages."graphql-language-service-cli"
  nodePackages."pyright"
  nodePackages."typescript"
  nodePackages."typescript-language-server"
  nodePackages."vscode-langservers-extracted"
  nodePackages."yaml-language-server"
  rust-analyzer
  sumneko-lua-language-server
  terraform-ls
]
