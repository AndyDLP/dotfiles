vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<leader>cn', '<cmd>cnext<cr>', { desc = "Next QuickFix item", silent = true })
vim.keymap.set('n', '<leader>cp', '<cmd>cprev<cr>', { desc = "Prev QuickFix item", silent = true })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })

function toggle_word_wrap()
  vim.wo.wrap = not vim.wo.wrap
end
vim.keymap.set({"n", "v"}, "<leader>tw", toggle_word_wrap, { desc = "[T]oggle [W]ord wrap" })

function ToLink()
  local char_to_hex = function(c)
    return string.format("%%%01X", string.byte(c))
  end
  local function urlencode(url)
    if url == nil then
      return
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
  end

  local origin = vim.fn.system("git remote -v | grep origin | head -n 1 | awk '{print $2}' | sed -E 'sA.*:.*\\/(.*)/(.*).gitA\\1/repos/\\2A'"):gsub("\n", "")
  local branch = urlencode(vim.fn.system("git branch --show-current"):gsub("\n", ""))
  local git_repo_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  -- set cwd to repo root
  vim.api.nvim_set_current_dir(git_repo_root)
  local path = vim.fn.expand("%")
  local line_num_start, line_num_end
  if vim.fn.mode() == 'V' then
    line_num_start = vim.fn.line('v')
    line_num_end = vim.fn.line('.')
    if line_num_start > line_num_end then
      line_num_start, line_num_end = line_num_end, line_num_start
    end
  else
    line_num_start = vim.api.nvim_win_get_cursor(0)[1]
    line_num_end = line_num_start
  end
  local res = "https://STASH_HOST_CHANGEME/projects/" .. origin .. "/browse/" .. path .. "?at=" .. branch
  if line_num_start == line_num_end then
    res = res .. "#" .. line_num_start
  else
    res = res .. "#" .. line_num_start .. "-" .. line_num_end
  end
  res = res:gsub("\n", "")
  vim.fn.setreg('+', res)
end
vim.keymap.set({"n","v"}, "<leader>cl", ToLink, { desc = "[C]opy [L]ink to current line(s)" })

function find_directory_and_focus()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local function open_nvim_tree(prompt_bufnr, _)
    actions.select_default:replace(function()
      local api = require("nvim-tree.api")

      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      api.tree.open()
      api.tree.find_file(selection.cwd .. "/" .. selection.value)
    end)
    return true
  end

  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
    attach_mappings = open_nvim_tree,
  })
end
vim.keymap.set("n", "fd", find_directory_and_focus)

-- dont put changed text into y register
vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true, silent = true })

vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
