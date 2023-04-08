self: super: {
  customTmux = {
    catppuccin = super.tmuxPlugins.catppuccin.overrideAttrs (old: {
      src = super.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "4e48b09a76829edc7b55fbb15467cf0411f07931";
        sha256 = "sha256-bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
      };
    });
  };
}
