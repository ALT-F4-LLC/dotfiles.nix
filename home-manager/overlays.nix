self: super:

let
  tabninePlatform = if (builtins.hasAttr super.stdenv.hostPlatform.system
    tabnineSupportedPlatforms) then
    builtins.getAttr (super.stdenv.hostPlatform.system)
    tabnineSupportedPlatforms
  else
    throw "Not supported on ${super.stdenv.hostPlatform.system}";
  tabnineSupportedPlatforms = {
    "x86_64-linux" = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "sha256-BLWJDua9EjAHjXg7+WBzsnPdbfYG/xDILs7WSIfqldc=";
    };
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      sha256 = "sha256-rLt7l+WmUTuKkkRg6pDEPinGatBmecDNg+IMjubniB4=";
    };
  };
  tabnineVersion = "4.4.90";
in {
  customTmux = with self; {
    tokyonight = pkgs.tmuxPlugins.mkTmuxPlugin rec {
      name = "tokyo-night-tmux";
      pluginName = "tokyo-night-tmux";
      rtpFilePath = "tokyo-night.tmux";
      src = fetchFromGitHub {
        owner = "janoamaral";
        repo = "tokyo-night-tmux";
        rev = "16469dfad86846138f594ceec780db27039c06cd";
        sha256 = "sha256-EKCgYan0WayXnkSb2fDJxookdBLW0XBKi2hf/YISwJE=";
      };
    };
  };

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
        rev = "bfc45c962a4e8da957e9972d4f4ddeda92580db0";
        sha256 = "sha256-M1YVigvvOmpt9+TbsCm/+hQ3r9YPQDW5ECM/qprWnyI=";
      };
    });

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

    tabnine = pkgs.tabnine.overrideAttrs (oldAttrs: {
      src = fetchurl {
        inherit (tabninePlatform) sha256;
        url =
          "https://update.tabnine.com/bundles/${tabnineVersion}/${tabninePlatform.name}/TabNine.zip";
      };
      version = tabnineVersion;
    });

    vim-just = pkgs.vimUtils.buildVimPlugin {
      name = "vim-just";
      src = pkgs.fetchFromGitHub {
        owner = "NoahTheDuke";
        repo = "vim-just";
        rev = "312615d5b4c4aa2595d697faca5af345ba8fe102";
        sha256 = "sha256-8qGFYRoVIiGB240wdM0o9hCMt65Gg4qIh7pvmW3DghU=";
      };
    };
  };
}
