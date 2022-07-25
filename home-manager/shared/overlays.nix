self: super:

let tabnine_version = "4.4.84";
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
        rev = "a5081776185e3c7f406e7fc3dd5f0a0ae0288e59";
        sha256 = "sha256-4pbwy+fEIaRrEvfie7LphD5oY4EVQaPZKRb5p9vujGk=";
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
        sha256 = "sha256-wBHjrcCmt6n7nQC/BuUrVJ3oqPG6WGMoaxrfjB3aA+k=";
        url =
          "https://update.tabnine.com/bundles/4.4.54/x86_64-apple-darwin/TabNine.zip";
      };
      version = tabnine_version;
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
