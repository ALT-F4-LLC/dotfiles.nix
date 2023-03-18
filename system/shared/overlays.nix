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

  customTmux = {
    catppuccin = super.tmuxPlugins.catppuccin.overrideAttrs(old: {
      src = super.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "8dd142b4e0244a357360cf87fb36c41373ab451f";
        sha256 = "sha256-KoGrA5Mgw52jU00bgirQb/E8GbsMkG1WVyS5NSFqv7o=";
      };
    });
  };

  customVim = with self; {
    catppuccin-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "catppuccin-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "nvim";
        rev = "e1fc2c3ade0d8872665d7570c493bbd5e11919c7";
        sha256 = "sha256-s8nMeBtDnf/L7/rYwmf6UexykfADXJx0fZoDg8JacGs=";
      };
    };

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
      rev = "da8dee3ccaf882d1bf653c34850041025616ceb5";
      sha256 = "sha256-MHb9Q7mwgWAs99vom6a2aODB40I9JTBaJnbvTYbMwiA=";
    };
  };
}
