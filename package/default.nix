{ pkgs }:

{
  thealtf4stream-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "TheAltF4Stream";
    src = ../config/nvim;
  };

  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "10de9ebf0bd8df8ff8593b0b87ec8bf3b715326f";
      sha256 = "sha256-NGhWF4/SEPww9e/wCDghGMSPZmmAbms6tn/IHqDMDkI=";
    };
  };
}
