vim.o.completeopt = 'menuone,noselect'
-- vim.o.spell = true
-- vim.o.spelllang = "en_gb"

vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winpos,winsize"

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- vim.go.lazyredraw = true
vim.g.have_nerd_font = true
vim.g.tmux_navigator_save_on_switch = 1
vim.o.conceallevel = 2

-- Set highlight on search
vim.o.hlsearch = true
vim.o.wrap = true

vim.o.cmdheight = 0

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

vim.o.foldenable = true
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.o.cursorline = true

-- disable mouse mode
vim.o.mouse = ''

vim.filetype.add({
  -- extension = {
  --   jinja = 'jinja',
  --   jinja2 = 'jinja',
  --   j2 = 'jinja',
  -- },
  pattern = {
    [".*/.*inventories.*%.yml"] = "yaml.ansible",
    [".*/.*playbooks.*%.yml"] = "yaml.ansible",
    [".*/.*roles.*%.yml"] = "yaml.ansible",
    [".*/.*roles.*%.yaml"] = "yaml.ansible",
    [".*/.*inventories.*%.yaml"] = "yaml.ansible",
    [".*/.*playbooks.*%.yaml"] = "yaml.ansible",
    [".*/.*ansible.*%.yaml"] = "yaml.ansible",
    [".*/.*ansible.*%.yml"] = "yaml.ansible",
    [".*Jenkinsfile"] = "groovy",
    ["Jenkinsfile"] = "groovy",
    [".*%.mdt"] = "markdown",
    [".*%.mdi"] = "markdown",
    -- [".*/.*kubernetes.*%.yaml"] = "kubernetes",
    -- [".*/.*k8s.*%.yaml"] = "kubernetes",
  },
})

vim.opt.showmode = false
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.inccommand = 'split'
vim.opt.scrolloff = 5

-- Enable break indent
vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.autochdir = false
vim.o.expandtab = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.g.autoformat = true

-- Set clipboard to system clipboard
vim.o.clipboard = 'unnamedplus'

function no_paste(reg)
    return function(lines, phase)
        -- Do nothing! We can't paste with OSC52
    end
end

-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     -- doesn't work with Windows Terminal :(
--     -- ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     -- ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--     -- ['+'] = vim.api.nvim_paste( (vim.fn.getreg('+', false)), true, -1 ),
--     -- ['*'] = vim.api.nvim_paste( (vim.fn.getreg('*', false)), true, -1 ),
--     -- ['+'] = vim.api.nvim_put( (vim.fn.getreg('+', false)), 'c', true, false ),
--     -- ['*'] = vim.api.nvim_put( (vim.fn.getreg('*', false)), 'c', true, false ),
--     -- ['+'] = require('vim').paste('+', -1),
--     -- ['*'] = require('vim').paste('*', -1),
--     ["+"] = no_paste("+"), -- Pasting disabled
--     ["*"] = no_paste("*"), -- Pasting disabled
--     -- ["+"] = 'echo lol',
--     -- ["*"] = 'echo lol',
--   },
-- }
