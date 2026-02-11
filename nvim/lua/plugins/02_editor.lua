return {
  {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    lazy = false,
    opts = {
      processor = "magick_cli",
        hijack_file_patterns = { "*.PNG", "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    }
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "<leader>J", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      -- { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      -- { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    keys = {
      {
        '<leader>onn',
        function()
          -- prompt for note name
          vim.ui.input({
            prompt = 'Note Name: ',
            default = '',
          }, function(input)
            if input then
              -- replace CHANGEME in template with input
              vim.cmd('Obsidian new ' .. input)
            else
              -- if no input, use default
              vim.cmd('Obsidian new')
            end
          end)
        end,
        mode = '',
        desc = '[O]bsidian [N]ew [N]ote',
      },
      {
        '<leader>onm',
        function()
          -- prompt for meeting name
          vim.ui.input({
            prompt = 'Meeting Name: ',
            -- default prefilled input in the ui box
            default = os.date('%Y-%m-%d - '),
          }, function(input)
            if input then
              -- replace CHANGEME in template with input
              vim.cmd('Obsidian new_from_template timestamps/meetings/' .. input .. ' template-meeting')
            else
              -- if no input, use default
              vim.cmd('Obsidian new_from_template timestamps/meetings/' ..
                os.date('%Y-%m-%d - untitled meeting') .. ' template-meeting')
            end
          end)

          -- vim.cmd('Obsidian new_from_template timestamps/meetings/CHANGEME template-meeting')
        end,
        mode = '',
        desc = '[O]bsidian [N]ew [M]eeting',
      },
      {
        '<leader>os',
        function()
          vim.cmd('Obsidian search')
        end,
        mode = '',
        desc = '[O]bsidian [S]earch',
      },
      {
        '<leader>or',
        function()
          vim.cmd('Obsidian rename')
        end,
        mode = '',
        desc = '[O]bsidian [R]ename',
      },
      {
        '<leader>ont',
        function()
          vim.cmd('Obsidian new_from_template')
        end,
        mode = '',
        desc = '[O]bsidian [N]ew from [T]emplate',
      },
      {
        '<leader>of',
        function()
          vim.cmd('Obsidian quick_switch')
        end,
        mode = '',
        desc = '[O]bsidian [F]iles',
      },
      {
        '<leader>om',
        function()
          vim.cmd('Obsidian tomorrow')
        end,
        mode = '',
        desc = '[O]bsidian to[M]orrow',
      },
      {
        '<leader>oy',
        function()
          vim.cmd('Obsidian yesterday')
        end,
        mode = '',
        desc = '[O]bsidian [Y]esterday',
      },
      {
        '<leader>ot',
        function()
          vim.cmd('Obsidian today')
        end,
        mode = '',
        desc = '[O]bsidian [T]oday',
      },
    },
    -- event = {
    --   "BufReadPre " .. vim.fn.expand "~" .. "/git/obsidian/**/*.md",
    --   "BufNewFile " .. vim.fn.expand "~" .. "/git/obsidian/**/*.md",
    -- },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- set to true if you want to use the old commands
      new_notes_location = "_inbox",
      notes_subdir = "_inbox",
      workspaces = {
        {
          name = "work",
          path = "~/git/obsidian/",
        },
      },
      completion = {
        -- Enables completion using nvim_cmp
        nvim_cmp = false,
        -- Enables completion using blink.cmp
        blink = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
        -- Set to false to disable new note creation in the picker
        create_new = true,
      },
      -- disable extra checkboxes so we just have ticked or not
      ---@field order? string[]
      checkbox = {
        order = { " ", "x" },
      },
      ui = {
        ignore_conceal_warn = true,
      },
      templates = {
        folder = "admin/templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        substitutions = {
          -- Custom substitution for the main heading (e.g., "Wednesday, August 13, 2025")
          formatted_long_date = function()
            return os.date("%A, %B %d, %Y")
          end,

          -- Custom substitution for the "Yesterday" link
          yesterday_link = function()
            local yesterday_ts = os.time() - 86400 -- Timestamp for yesterday
            local year = os.date("%Y", yesterday_ts)
            local month_num = os.date("%m", yesterday_ts)
            local month_name = os.date("%B", yesterday_ts)
            local full_date_with_day = os.date("%Y-%m-%d-%A", yesterday_ts) -- e.g., "2025-08-12-Tuesday"

            -- Construct the path as per your original template: timestamps/YYYY/MM-MMMM/YYYY-MM-DD-dddd
            local path = string.format("timestamps/%s/%s-%s/%s", year, month_num, month_name, full_date_with_day)
            return string.format("[[%s|Yesterday]]", path)
          end,

          -- Custom substitution for the "Today" link
          today_link = function()
            local today_ts = os.time() -- Timestamp for today
            local year = os.date("%Y", today_ts)
            local month_num = os.date("%m", today_ts)
            local month_name = os.date("%B", today_ts)
            local full_date_with_day = os.date("%Y-%m-%d-%A", today_ts) -- e.g., "2025-08-13-Wednesday"

            -- Construct the path: timestamps/YYYY/MM-MMMM/YYYY-MM-DD-dddd
            local path = string.format("timestamps/%s/%s-%s/%s", year, month_num, month_name, full_date_with_day)
            return string.format("[[%s|Today]]", path)
          end,

          -- Custom substitution for the "Tomorrow" link
          tomorrow_link = function()
            local tomorrow_ts = os.time() + 86400 -- Timestamp for tomorrow
            local year = os.date("%Y", tomorrow_ts)
            local month_num = os.date("%m", tomorrow_ts)
            local month_name = os.date("%B", tomorrow_ts)
            local full_date_with_day = os.date("%Y-%m-%d-%A", tomorrow_ts) -- e.g., "2025-08-14-Thursday"

            -- Construct the path: timestamps/YYYY/MM-MMMM/YYYY-MM-DD-dddd
            local path = string.format("timestamps/%s/%s-%s/%s", year, month_num, month_name, full_date_with_day)
            return string.format("[[%s|Tomorrow]]", path)
          end,
        },
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "timestamps/",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y/%m-%B/%Y-%m-%-d-%A",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily_note" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        -- template = "template-daily-note",
        template = "daily-note",
        -- Optional, if you want `Obsidian yesterday` to return the last work day or `Obsidian tomorrow` to return the next work day.
        workdays_only = true,
      },
      -- THIS IS THE DEFAULT NOTE ID FUNCTION - WE WANT TO OVERRIDE IT TO USE the NAME as ID
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      -- note_id_func = function(title)
      --   -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      --   -- In this case a note with the title 'My new note' will be given an ID that looks
      --   -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
      --   -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
      --   local suffix = ""
      --   if title ~= nil then
      --     -- If title is given, transform it into valid file name.
      --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      --   else
      --     -- If title is nil, just add 4 random uppercase letters to the suffix.
      --     for _ = 1, 4 do
      --       suffix = suffix .. string.char(math.random(65, 90))
      --     end
      --   end
      --   return tostring(os.time()) .. "-" .. suffix
      -- end,

      -- WE WANT TO OVERRIDE IT TO USE the NAME as ID
      note_id_func = function(title)
        -- Use the title as the ID, replacing spaces with dashes and removing invalid characters
        if title then
          return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          return "untitled-note"
        end
      end,
    },
  },
  {
    -- open files at linenumber from stacktrace
    'lewis6991/fileline.nvim',
    lazy = false,
  },
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    -- lazy = false,
  },
  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    event = "VeryLazy",
    keys = {
      {
        '<leader>sr',
        function()
          require('grug-far').open({
            prefills = {
              search = vim.fn.expand('<cword>'),
              paths = vim.fn.expand("%"),
            },
          })
        end,
        desc = 'Grug [S]earch and [R]eplace',
      },
    },
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup({
        -- options, see Configuration section below
        -- there are no required options atm
      });
    end
  },
  -- {
  --   'romgrk/todoist.nvim',
  --   enabled = true,
  --   event = "VeryLazy",
  -- },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
      routes = {
        { -- route long messages to split
          filter = {
            event = "msg_show",
            any = { { min_height = 5 }, { min_width = 200 } },
            ["not"] = {
              kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
            },
            blocking = false,
          },
          view = "messages",
          opts = { stop = true },
        },
        { -- route long messages to split
          filter = {
            event = "msg_show",
            any = { { min_height = 5 }, { min_width = 200 } },
            ["not"] = {
              kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
            },
            blocking = false,
          },
          view = "mini",
        },
        { -- hide `yanked` message
          filter = {
            event = "msg_show",
            kind = "",
            any = {
              { find = "yanked" },
              { find = "more lines" },
              { find = "added to clipboard" },

            },
          },
          opts = { skip = true },
        },
        { -- hide `yanked` message
          filter = {
            event = "msg_show",
            kind = "error",
            any = {
              { find = "Cannot make changes, 'modifiable' is off" },
              { find = "provider returned invalid data" },
            },
          },
          opts = { skip = true },
        },
        { -- hide `written` message
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        { -- send annoying msgs to mini
          filter = {
            event = "msg_show",
            any = {
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "fewer lines" },
            },
          },
          view = "mini",
        },
      },
      views = {
        split = {
          win_options = { wrap = false },
          size = 16,
          close = { keys = { "q", "<CR>", "<Esc>" } },
        },
        popup = {
          win_options = { wrap = false },
        },
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  -- {
  --   'kevinhwang91/nvim-bqf',
  --   event = "QuickFixCmdPre,QuickFixCmdPost",
  --   opts = {
  --     auto_enable = true,
  --     auto_resize_height = true,
  --   },
  -- },
  {
    "2nthony/sortjson.nvim",
    cmd = {
      "SortJSONByAlphaNum",
      "SortJSONByAlphaNumReverse",
      "SortJSONByKeyLength",
      "SortJSONByKeyLengthReverse",
    },
    -- options with default values
    opts = {
      jq = "jq",          -- jq command, you can try `jaq` `gojq` etc.
      log_level = "WARN", -- log level, see `:h vim.log.levels`, when parsing json failed
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = "VimEnter",
    keys = {
      {
        '<leader>ce',
        function()
          vim.cmd('Copilot panel')
        end,
        desc = '[C]opilot [P]anel'
      },
      {
        '<leader>tc',
        function()
          if vim.g.copilot_enabled == 1 then
            vim.cmd('Copilot disable')
          else
            vim.cmd('Copilot enable')
          end
        end,
        desc = '[T]oggle [C]opilot'
      }
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    event = "BufRead",
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end
      })
    end,
    keys = {
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open All Folds'
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close All Folds'
      },
    },
  },
  {
    'echasnovski/mini.comment',
    version = false,
    opts = {
      ignore_blank_line = true
    },
    event = "BufRead",
  },
  {
    'echasnovski/mini.ai',
    version = false,
    event = "BufEnter",
  },
  {
    'echasnovski/mini.operators',
    version = false,
    event = "BufEnter",
  },
  {
    'tpope/vim-sleuth',
    event = "BufRead",
  },
  {
    "cappyzawa/trim.nvim",
    opts = {
      trim_last_line = false,
    },
    event = "InsertEnter",
  },
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      delay = 0,
      plugins = {
        registers = false,
      },
      icons = {
        spec = {
          { '<leader>c', group = '[C]ode',     mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },

        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
    }
  },
  {
    'aymericbeaumet/vim-symlink',
    dependencies = {
      'moll/vim-bbye',
    },
  },
  {
    "lukas-reineke/headlines.nvim",
    opts = function()
      local opts = {}
      for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
        opts[ft] = {
          headline_highlights = {},
          -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
          bullets = {},
          fat_headline_lower_string = "-",
        }
        for i = 1, 6 do
          local hl = "Headline" .. i
          vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
          table.insert(opts[ft].headline_highlights, hl)
        end
      end
      return opts
    end,
    ft = { "markdown", "norg", "rmd", "org" },
    config = function(_, opts)
      -- PERF: schedule to prevent headlines slowing down opening a file
      vim.schedule(function()
        require("headlines").setup(opts)
        require("headlines").refresh()
      end)
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- 'fdschmidt93/telescope-egrepify.nvim',
      -- { 'nvim-telescope/telescope-ui-select.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
        extensions = {
          -- fzf = {
          --   override_generic_sorter = true,
          --   override_file_sorter = true,
          -- },
          -- egrepify = {
          --   permutations = false, -- opt-in to imply AND & match all permutations of prompt tokens
          --   prefixes = {
          --     -- ADDED ! to invert matches
          --     -- example prompt: ! sorter
          --     -- matches all lines that do not comprise sorter
          --     -- rg --invert-match -- sorter
          --     ["!"] = {
          --       flag = "invert-match",
          --     },
          --     -- HOW TO OPT OUT OF PREFIX
          --     -- ^ is not a default prefix and safe example
          --     ["^"] = false
          --   },
          -- },
          -- persisted = {
          --   layout_config = {
          --     width = 0.5,
          --     height = 0.5,
          --   },
          -- },
        },
      }
      -- require('telescope').load_extension('egrepify')
      pcall(require('telescope').load_extension, 'fzf')
    end,
    keys = {
      {
        '<leader>se',
        function()
          require('telescope.builtin').builtin()
        end,
        desc = '[S]earch Telescope [E]xtensions'
      },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 9,
            previewer = false,
          })
        end,
        desc = '[/] Fuzzily search in current buffer'
      },
      {
        '<leader>gf',
        function()
          require('telescope.builtin').git_files()
        end,
        desc = 'Search [G]it [F]iles'
      },
      {
        '<leader>sf',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = '[S]earch [F]iles'
      },
      {
        '<leader>sh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = '[S]earch [H]elp'
      },
      {
        '<leader>sw',
        function()
          require('telescope.builtin').grep_string()
        end,
        desc = '[S]earch current [W]ord'
      },
      {
        '<leader>sg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = '[S]earch by [G]rep'
      },
      {
        '<leader>sD',
        function()
          require('telescope.builtin').diagnostics()
        end,
        desc = '[S]earch [D]iagnostics'
      },
      {
        '<leader>ss',
        function()
          require('telescope.builtin').sessions()
        end,
        desc = '[S]earch [S]essions'
      },
      {
        '<leader>st',
        function()
          require('telescope.builtin').treesitter()
        end,
        desc = '[S]earch [T]reesitter'
      },
      {
        '<leader>sc',
        function()
          require('telescope.builtin').commands()
        end,
        desc = '[S]earch [C]ommands'
      },
      {
        '<leader>so',
        function()
          require('telescope.builtin').oldfiles()
        end,
        desc = '[S]earch [O]ldfiles'
      },
      {
        '<leader>sb',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[S]earch [B]uffers'
      },
      {
        '<leader>sp',
        function()
          require('telescope.builtin').project()
        end,
        desc = '[S]earch [P]roject'
      },
      {
        '<leader>sl',
        function()
          require('telescope.builtin').lsp_references()
        end,
        desc = '[S]earch [L]sp References'
      },
      {
        '<leader>sd',
        function()
          require('telescope.builtin').lsp_definitions()
        end,
        desc = '[S]earch [D]efinitions'
      },
      {
        '<leader>sy',
        function()
          require('telescope.builtin').lsp_type_definitions()
        end,
        desc = '[S]earch t[Y]pe Definitions'
      },
      {
        '<leader>si',
        function()
          require('telescope.builtin').lsp_implementations()
        end,
        desc = '[S]earch [I]mplementations'
      },
    },
  },
}
