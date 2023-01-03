self: super:

let
  sources = import ../nix/sources.nix;
in {
  customTmux = with self; {
    catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = "catppuccin";
      src = sources."catppuccin-tmux";
      version = "unstable-2022-09-14";
    };
  };
  customVim = with self; {
    thealtf4stream = pkgs.vimUtils.buildVimPlugin {
      name = "TheAltF4Stream";
      src = ./config/nvim;
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
