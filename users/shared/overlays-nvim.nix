self: super:

rec {
  customVim = with self; {
    cmp-tabnine = pkgs.vimPlugins.cmp-tabnine.overrideAttrs (oldAttrs: { 
      buildInputs = [ customVim.tabnine ];
      postFixup = ''
        mkdir -p $target/binaries/${customVim.tabnine.version}
        ln -s ${customVim.tabnine}/bin/ $target/binaries/${customVim.tabnine.version}/${customVim.tabnine.passthru.platform}
      '';
      src = fetchFromGitHub {
        owner = "tzachar";
        repo = "cmp-tabnine";
        rev = "e23d32a76304496aade4e4b285751a6a8b505491";
        sha256 = "sha256-ymqNPqm1pyIGLYPvJzSumiPkjQ27A/yqhl/zMwg0OTY=";
      };
    } );
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
      src = fetchFromGitHub {
        owner = "lspcontainers";
        repo = "lspcontainers.nvim";
        rev = "3c9d2156a447eb111ec60f4358768eb7510c5d0d";
        sha256 = "sha256-HG1d9oebMAKGyFhPnA5nnfLWivGgGi2MY1AF+u+jfhA=";
      };
    };
    tabnine = pkgs.tabnine.overrideAttrs (oldAttrs: { 
      version = "4.4.36";
      src = fetchurl {
        sha256 = "sha256-3/Pn/3k4zFYORJN4AZ8sD9bTW5o86M0BS7IiiosQ3NI=";
        url = "https://update.tabnine.com/bundles/4.4.36/x86_64-unknown-linux-musl/TabNine.zip";
      };
    } );
  };
}
