{ pkgs, ... }:

with pkgs; [
  # programs
  awscli2
  azure-cli
  cargo
  doppler
  fd
  google-cloud-sdk
  jetbrains.datagrip
  jq
  just
  k9s
  kubectl
  lazydocker
  niv
  nodejs-16_x
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
