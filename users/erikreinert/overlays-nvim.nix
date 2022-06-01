self: super:

let sources = import ../../nix/sources.nix; in rec {
  customVim = with self; {
    cmp-buffer = vimUtils.buildVimPlugin {
      name = "cmp-buffer";
      src = sources."cmp-buffer";
    };
    cmp-cmdline = vimUtils.buildVimPlugin {
      name = "cmp-cmdline";
      src = sources."cmp-cmdline";
    };
    cmp-nvim-lsp = vimUtils.buildVimPlugin {
      name = "cmp-nvim-lsp";
      src = sources."cmp-nvim-lsp";
    };
    cmp-path = vimUtils.buildVimPlugin {
      name = "cmp-path";
      src = sources."cmp-path";
    };
    cmp-tabnine = vimUtils.buildVimPlugin {
      name = "cmp-tabnine";
      src = sources."cmp-tabnine";
      buildPhase = ":";
    };
    cmp-treesitter = vimUtils.buildVimPlugin {
      name = "cmp-treesitter";
      src = sources."cmp-treesitter";
    };
    cmp-vsnip = vimUtils.buildVimPlugin {
      name = "cmp-vsnip";
      src = sources."cmp-vsnip";
    };
    gitsigns-nvim = vimUtils.buildVimPlugin {
      name = "gitsigns.nvim";
      src = sources."gitsigns.nvim";
      buildPhase = ":";
    };
    indent-blankline-nvim = vimUtils.buildVimPlugin {
      name = "indent-blankline.nvim";
      src = sources."indent-blankline.nvim";
    };
    lsp-colors-nvim = vimUtils.buildVimPlugin {
      name = "lsp-colors.nvim";
      src = sources."lsp-colors.nvim";
    };
    lsp_extensions-nvim = vimUtils.buildVimPlugin {
      name = "lsp_extensions.nvim";
      src = sources."lsp_extensions.nvim";
    };
    lspcontainers-nvim = vimUtils.buildVimPlugin {
      name = "lspcontainers.nvim";
      src = sources."lspcontainers.nvim";
    };
    lspkind-nvim = vimUtils.buildVimPlugin {
      name = "lspkind-nvim";
      src = sources."lspkind-nvim";
    };
    lualine-nvim = vimUtils.buildVimPlugin {
      name = "lualine.nvim";
      src = sources."lualine.nvim";
      buildPhase = ":";
    };
    nerdcommenter = vimUtils.buildVimPlugin {
      name = "nerdcommenter";
      src = sources."nerdcommenter";
    };
    nvim-cmp = vimUtils.buildVimPlugin {
      name = "nvim-cmp";
      src = sources."nvim-cmp";
      buildPhase = ":";
    };
    nvim-lspconfig = vimUtils.buildVimPlugin {
      name = "nvim-lspconfig";
      src = sources."nvim-lspconfig";
      buildPhase = ":";
    };
    nvim-treesitter = vimUtils.buildVimPlugin {
      name = "nvim-treesitter";
      src = sources."nvim-treesitter";
    };
    nvim-treesitter-context = vimUtils.buildVimPlugin {
      name = "nvim-treesitter-context";
      src = sources."nvim-treesitter-context";
      buildPhase = ":";
    };
    nvim-web-devicons = vimUtils.buildVimPlugin {
      name = "nvim-web-devicons";
      src = sources."nvim-web-devicons";
    };
    plenary-nvim = vimUtils.buildVimPlugin {
      name = "plenary.nvim";
      src = sources."plenary.nvim";
      buildPhase = ":";
    };
    popup-nvim = vimUtils.buildVimPlugin {
      name = "popup.nvim";
      src = sources."popup.nvim";
    };
    quick-scope = vimUtils.buildVimPlugin {
      name = "quick-scope";
      src = sources."quick-scope";
    };
    telescope-nvim = vimUtils.buildVimPlugin {
      name = "telescope.nvim";
      src = sources."telescope.nvim";
      buildPhase = ":";
    };
    tokyonight-nvim = vimUtils.buildVimPlugin {
      name = "tokyonight.nvim";
      src = sources."tokyonight.nvim";
    };
    trouble-nvim = vimUtils.buildVimPlugin {
      name = "trouble.nvim";
      src = sources."trouble.nvim";
    };
    vim-floaterm = vimUtils.buildVimPlugin {
      name = "vim-floaterm";
      src = sources."vim-floaterm";
    };
    vim-hardtime = vimUtils.buildVimPlugin {
      name = "vim-hardtime";
      src = sources."vim-hardtime";
    };
    vim-vsnip = vimUtils.buildVimPlugin {
      name = "vim-vsnip";
      src = sources."vim-vsnip";
    };
    vim-prisma = vimUtils.buildVimPlugin {
      name = "vim-prisma";
      src = sources."vim-prisma";
    };
    vim-terraform = vimUtils.buildVimPlugin {
      name = "vim-terraform";
      src = sources."vim-terraform";
      buildPhase = ":";
    };
  };
}