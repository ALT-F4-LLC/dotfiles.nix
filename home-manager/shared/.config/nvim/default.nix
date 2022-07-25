{ lib, ... }:
''
lua << EOF
${lib.strings.fileContents ./vim.lua}
${lib.strings.fileContents ./theme.lua}
${lib.strings.fileContents ./languages.lua}
${lib.strings.fileContents ./treesitter.lua}
${lib.strings.fileContents ./completion.lua}
${lib.strings.fileContents ./telescope.lua}
${lib.strings.fileContents ./floaterm.lua}
${lib.strings.fileContents ./extras.lua}
EOF
''
