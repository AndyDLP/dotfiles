-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- local group = vim.api.nvim_create_augroup("PersistedHooks", {})
-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = "PersistedTelescopeLoadPre",
--   group = group,
--   callback = function(session)
--     -- Save the currently loaded session using a global variable
--     require("persisted").save({ session = vim.g.persisted_loaded_session })
--
--     -- Delete all of the open buffers
--     vim.api.nvim_input("<ESC>:%bd!<CR>")
--   end,
-- })

-- set working directory to git root
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = function()
    local function get_git_root()
      local dot_git_path = vim.fn.finddir(".git", ".;")
      return vim.fn.fnamemodify(dot_git_path, ":h")
    end
    vim.api.nvim_set_current_dir(get_git_root())
  end,
})


function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
