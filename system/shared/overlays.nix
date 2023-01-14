self: super: {
  customBat = with self; {
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
      sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
    };
  };

  customRofi = with self; {
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "rofi";
      rev = "5350da41a11814f950c3354f090b90d4674a95ce";
      sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
    };
  };

  customTmux = with self; {
    catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "catppuccin";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "d9e5c6d1e3b2c6f6f344f7663691c4c8e7ebeb4c";
        sha256 = "sha256-k0nYjGjiTS0TOnYXoZg7w9UksBMLT+Bq/fJI3f9qqBg=";
      };
      version = "unstable-2022-09-14";
    };
  };

  customVim = with self; {
    thealtf4stream = pkgs.vimUtils.buildVimPlugin {
      name = "TheAltF4Stream";
      src = ../../config/nvim;
    };

    vim-just = pkgs.vimUtils.buildVimPlugin {
      name = "vim-just";
      src = pkgs.fetchFromGitHub {
        owner = "NoahTheDuke";
        repo = "vim-just";
        rev = "838c9096d4c5d64d1000a6442a358746324c2123";
        sha256 = "sha256-DSC47z2wOEXvo2kGO5JtmR3hyHPiYXrkX7MgtagV5h4=";
      };
    };
  };

  customZsh = with self; {
    zsh-z = pkgs.fetchFromGitHub {
      owner = "agkozak";
      repo = "zsh-z";
      rev = "82f5088641862d0e83561bb251fb60808791c76a";
      sha256 = "sha256-6BNYzfTcjWm+0lJC83IdLxHwwG4/DKet2QNDvVBR6Eo=";
    };
  };
}
