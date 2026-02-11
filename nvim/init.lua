-- Set <space> as the leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- if vim.g.vscode then
--   -- VSCode Neovim
--   require "vsc.keymaps"
-- else
  -- Ordinary Neovim
  -- Install plugins
require('core.lazy')
require('core.keymaps')
require('core.options')
require('core.autocmds')

  -- require('core.lsp')
  -- require('core.cmp')
-- end
