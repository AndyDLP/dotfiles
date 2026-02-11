return {
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufRead',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl = true,
      current_line_blame = true,
    },
    keys = {
      {
        '<leader>hp',
        function()
          require('gitsigns').preview_hunk()
        end,
        desc = '[P]review [H]unk',
      },
      {
        '<leader>hs',
        function()
          require('gitsigns').stage_hunk()
        end,
        desc = '[S]tage [H]unk',
      },
      {
        '<leader>hr',
        function()
          require('gitsigns').reset_hunk()
        end,
        desc = '[R]eset [H]unk',
      },
      {
        '<leader>hS',
        function()
          require('gitsigns').stage_buffer()
        end,
        desc = '[S]tage [B]uffer',
      },
      {
        '<leader>hu',
        function()
          require('gitsigns').undo_stage_hunk()
        end,
        desc = '[U]ndo [S]tage [H]unk',
      },
      {
        '<leader>hR',
        function()
          require('gitsigns').reset_buffer()
        end,
        desc = '[R]eset [B]uffer',
      },
      {
        '<leader>hb',
        function()
          require('gitsigns').blame_line { full = true }
        end,
        desc = '[B]lame [L]ine',
      },
      {
        '<leader>tb',
        function()
          require('gitsigns').toggle_current_line_blame()
        end,
        desc = '[T]oggle [B]lame',
      },
      {
        '<leader>hd',
        function()
          require('gitsigns').diffthis()
        end,
        desc = '[D]iff [T]his',
      },
      {
        '<leader>hD',
        function()
          require('gitsigns').diffthis('~')
        end,
        desc = '[D]iff [T]his [~]',
      },
      {
        '<leader>td',
        function()
          require('gitsigns').toggle_deleted()
        end,
        desc = '[T]oggle [D]eleted',
      },
    },
  },
}
