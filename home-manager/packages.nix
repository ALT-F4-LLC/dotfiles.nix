{ pkgs, ... }:

with pkgs; [
  # programs
  awscli2
  azure-cli
  cargo
  doppler
  fd
  gcc
  ghc
  google-cloud-sdk
  jetbrains.datagrip
  jq
  jsonnet
  just
  k9s
  kubectl
  lazydocker
  nodejs
  powershell
  pulumi-bin
  python3Full
  ripgrep
  rustc
  rustfmt
  terraform
  virtualenv
  yarn

  # language servers
  gopls
  #haskell-language-server
  jsonnet-language-server
  nil
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
