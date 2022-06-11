self: super:

let sources = import ../../nix/sources.nix; in rec {
  customVim = with self; {
    jsonnet-language-server = buildGo117Module rec {
      pname = "jsonnet-language-server";
      version = "0.7.2";
      src = fetchFromGitHub {
        owner = "grafana";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-hI8eGfHC7la52nImg6BaBxdl9oD/J9q3F3+xbsHrn30=";
      };
      vendorSha256 = "sha256-UEQogVVlTVnSRSHH2koyYaR9l50Rn3075opieK5Fu7I=";
    }; 
    lspcontainers-nvim = vimUtils.buildVimPlugin {
      name = "lspcontainers.nvim";
      src = sources."lspcontainers.nvim";
    };
  };
}
