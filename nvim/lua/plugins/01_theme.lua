return {
  {
    "binhtran432k/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    init = function()
      vim.api.nvim_command(':colorscheme dracula')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    lazy = true,
    event = 'BufRead',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      {
        '<C-n>',
        function()
          vim.api.nvim_command(':bnext')
        end,
        desc = 'Next [N]ext buffer'
      },
      {
        '<C-p>',
        function()
          vim.api.nvim_command(':bprevious')
        end,
        desc = 'Previous [P]revious buffer'
      },
    },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'dracula',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {},
          lualine_x = {
            {
              'searchcount',
              maxcount = 9999,
              -- timeout = 500,
            },
          },
          lualine_y = { 'filesize', 'encoding', 'fileformat', 'filetype' },
          lualine_z = { 'progress', 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_a = { 'buffers' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'nvim_treesitter#statusline' }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = { 'fzf', 'nvim-tree' }
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        '<leader>f',
        function()
          vim.api.nvim_command(':NvimTreeFindFile')
        end,
        desc = 'Open current [F]ile'
      },
      {
        '<C-t>',
        function()
          vim.api.nvim_command(':NvimTreeFocus')
        end,
        desc = 'Toggle [T]ree'
      },
    },
    config = function()
      require("nvim-tree").setup {
        view = {
          adaptive_size = true,
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
        },
        filters = {
          git_ignored = true,
          dotfiles = true,
          git_clean = false,
          no_buffer = false,
          custom = {},
          exclude = {},
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = false,
        },
      }
    end,
  },
}
