self: super:
{
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
}
