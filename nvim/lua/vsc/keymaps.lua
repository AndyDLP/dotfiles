-- VSCode Neovim keymaps
-- Only includes VSCode commands that are verified to exist

local vscode = require('vscode')

-- Disable space in normal and visual mode (leader key)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Word wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Center screen after search navigation
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })

-- Don't put changed text into yank register
vim.keymap.set('n', 'c', '"_c', { noremap = true, silent = true })
vim.keymap.set('n', 'C', '"_C', { noremap = true, silent = true })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", function()
  vscode.action('workbench.action.files.save')
end, { desc = "Save file" })

-- Clear search highlight on escape
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search highlight" })

-- QuickFix navigation (Problems panel in VSCode)
vim.keymap.set('n', '<leader>cn', function()
  vscode.action('editor.action.marker.nextInFiles')
end, { desc = "Next problem", silent = true })

vim.keymap.set('n', '<leader>cp', function()
  vscode.action('editor.action.marker.prevInFiles')
end, { desc = "Previous problem", silent = true })

vim.keymap.set('n', '<leader>q', function()
  vscode.action('workbench.actions.view.problems')
end, { desc = 'Open problems panel' })

-- Toggle word wrap
vim.keymap.set({"n", "v"}, "<leader>tw", function()
  vscode.action('editor.action.toggleWordWrap')
end, { desc = "Toggle word wrap" })

-- File navigation and search
vim.keymap.set("n", "<leader>sf", function()
  vscode.action('workbench.action.quickOpen')
end, { desc = "Search files" })

vim.keymap.set("n", "<leader>sg", function()
  vscode.action('workbench.action.findInFiles')
end, { desc = "Search in files (grep)" })

vim.keymap.set("n", "<leader>sb", function()
  vscode.action('workbench.action.showAllEditors')
end, { desc = "Search buffers" })

-- Search commands
vim.keymap.set("n", "<leader>sg", function()
  vscode.action('workbench.action.findInFiles')
end, { desc = "Search in workspace (grep)" })

vim.keymap.set("n", "<leader>sf", function()
  vscode.action('workbench.action.quickOpen')
end, { desc = "Search files (quick open)" })

-- File explorer
vim.keymap.set("n", "<leader>e", function()
  vscode.action('workbench.view.explorer')
end, { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader>f", function()
  vscode.call('workbench.files.action.showActiveFileInExplorer')
end, { desc = "Reveal file in explorer" })

-- Navigate between editor groups
vim.keymap.set("n", "<C-h>", function()
  vscode.action('workbench.action.navigateLeft')
end, { desc = "Navigate left" })

vim.keymap.set("n", "<C-l>", function()
  vscode.action('workbench.action.navigateRight')
end, { desc = "Navigate right" })

vim.keymap.set("n", "<C-k>", function()
  vscode.action('workbench.action.navigateUp')
end, { desc = "Navigate up" })

vim.keymap.set("n", "<C-j>", function()
  vscode.action('workbench.action.navigateDown')
end, { desc = "Navigate down" })

-- LSP/Code actions
vim.keymap.set("n", "gf", function()
  vscode.action('editor.action.openLink')
end, { desc = "Go to file under cursor" })

vim.keymap.set("n", "gd", function()
  vscode.action('editor.action.revealDefinition')
end, { desc = "Go to definition" })

vim.keymap.set("n", "gD", function()
  vscode.action('editor.action.revealDeclaration')
end, { desc = "Go to declaration" })

vim.keymap.set("n", "gi", function()
  vscode.action('editor.action.goToImplementation')
end, { desc = "Go to implementation" })

vim.keymap.set("n", "gr", function()
  vscode.action('editor.action.goToReferences')
end, { desc = "Go to references" })

vim.keymap.set("n", "gy", function()
  vscode.action('editor.action.goToTypeDefinition')
end, { desc = "Go to type definition" })

vim.keymap.set("n", "K", function()
  vscode.action('editor.action.showHover')
end, { desc = "Show hover documentation" })

vim.keymap.set("n", "<leader>rn", function()
  vscode.action('editor.action.rename')
end, { desc = "Rename symbol" })

vim.keymap.set({"n", "v"}, "<leader>ca", function()
  vscode.action('editor.action.quickFix')
end, { desc = "Code action" })

vim.keymap.set("n", "<leader>F", function()
  vscode.action('editor.action.formatDocument')
end, { desc = "Format document" })

vim.keymap.set("v", "<leader>cf", function()
  vscode.action('editor.action.formatSelection')
end, { desc = "Format selection" })

-- Diagnostics
vim.keymap.set("n", "[d", function()
  vscode.action('editor.action.marker.prev')
end, { desc = "Previous diagnostic" })

vim.keymap.set("n", "]d", function()
  vscode.action('editor.action.marker.next')
end, { desc = "Next diagnostic" })

-- Git
vim.keymap.set("n", "<leader>go", function()
  vscode.action('workbench.view.scm')
end, { desc = "Open git view" })

vim.keymap.set("n", "<leader>gb", function()
  vscode.action('git.checkout')
end, { desc = "Switch branch" })

vim.keymap.set("n", "<leader>gd", function()
  vscode.action('git.openChange')
end, { desc = "View git diff" })

vim.keymap.set("n", "<leader>gm", function()
  vscode.action('git.checkout')
end, { desc = "Checkout branch" })

vim.keymap.set("n", "<leader>gca", function()
  vscode.action('git.stageAll')
  vscode.action('git.commit')
end, { desc = "Stage all and commit" })

vim.keymap.set("n", "<leader>gp", function()
  vscode.action('git.fetch')
  vscode.action('git.pull')
  -- vscode.action('git.push')
end, { desc = "Fetch, pull, and push" })

-- Comments
vim.keymap.set({"n", "v"}, "<leader>/", function()
  vscode.action('editor.action.commentLine')
end, { desc = "Toggle comment" })

-- Fold
vim.keymap.set("n", "za", function()
  vscode.action('editor.toggleFold')
end, { desc = "Toggle fold" })

vim.keymap.set("n", "zM", function()
  vscode.action('editor.foldAll')
end, { desc = "Fold all" })

vim.keymap.set("n", "zR", function()
  vscode.action('editor.unfoldAll')
end, { desc = "Unfold all" })

-- Buffer/Tab navigation
vim.keymap.set("n", "<C-p>", function()
  vscode.action('workbench.action.previousEditor')
end, { desc = "Previous buffer" })

vim.keymap.set("n", "<C-n>", function()
  vscode.action('workbench.action.nextEditor')
end, { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bd", function()
  vscode.action('workbench.action.closeActiveEditor')
end, { desc = "Close buffer" })

vim.keymap.set("n", "<leader>co", function()
  vscode.action('workbench.action.closeOtherEditors')
end, { desc = "Close other editors" })

-- Command palette
vim.keymap.set("n", "<leader><leader>", function()
  vscode.action('workbench.action.showCommands')
end, { desc = "Command palette" })

-- Terminal
vim.keymap.set("n", "<leader>tt", function()
  vscode.action('workbench.action.terminal.toggleTerminal')
end, { desc = "Toggle terminal" })

-- Workspace symbols
vim.keymap.set("n", "<leader>ss", function()
  vscode.action('workbench.action.showAllSymbols')
end, { desc = "Search workspace symbols" })

-- Document symbols
vim.keymap.set("n", "<leader>sds", function()
  vscode.action('workbench.action.gotoSymbol')
end, { desc = "Search document symbols" })
