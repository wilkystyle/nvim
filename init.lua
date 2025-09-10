----------------------------------------------------------------------------------
--- BOOTSTRAP LAZY.NVIM
----------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


----------------------------------------------------------------------------------
--- ANNOYANCES
----------------------------------------------------------------------------------
vim.opt.backup = false       -- No backup file, part 1
vim.opt.writebackup = false  -- No backup file, part 2

-- Add a jump to the jumplist via m' when using k with a count.
vim.keymap.set('n', 'k', function()
  return (vim.v.count > 1 and "m'" .. vim.v.count or '') .. 'k'
end, { expr = true, noremap = true })

-- Add a jump to the jumplist via m' when using j with a count.
vim.keymap.set('n', 'j', function()
  return (vim.v.count > 1 and "m'" .. vim.v.count or '') .. 'j'
end, { expr = true, noremap = true })


----------------------------------------------------------------------------------
--- OPTIONS
----------------------------------------------------------------------------------
vim.opt.clipboard:append { "unnamed", "unnamedplus" }  -- Use system clipboard by default

vim.opt.hlsearch = true                                -- Highlight matches while searching
vim.opt.ignorecase = true                              -- Ignore case while searching, by default
vim.opt.incsearch = true                               -- Enable incremental search by default

vim.opt.expandtab = true                               -- Use spaces by default instead of tabs
vim.opt.tabstop = 4                                    -- How wide a tab looks when displayed
vim.opt.shiftwidth = 4                                 -- How many spaces to indent by
vim.opt.softtabstop = 4                                -- How many spaces to insert when pressing TAB

vim.opt.number = true                                  -- Enable line numbers
vim.opt.rnu = true                                     -- Make the line numbers relative

vim.g.mapleader = " "                                  -- Set space as the leader key


----------------------------------------------------------------------------------
--- AUTOCMDS
----------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufReadCmd', { pattern = '*.whl', command = 'call zip#Browse(expand("<amatch>"))' })


----------------------------------------------------------------------------------
--- PLUGINS
----------------------------------------------------------------------------------
require("lazy").setup({
  { "cohama/lexima.vim" },                -- Auto-pairing of characters
  { "michaeljsmith/vim-indent-object" },  -- Indentation as a vim text object
  { "scrooloose/nerdtree" },              -- Nerdtree: Sidebar for browsing files

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false,
    keys = {
      { "<leader>j", "<cmd>Oil<cr>" }
    },
    opts = {
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    }
  },

  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gb", "<cmd>Git blame<cr>" },
      { "<leader>gf", "<cmd>!git fullup<cr>" },
      { "<leader>gh", "<cmd>Gclog! -256 % | copen | only<cr>" },
      { "<leader>gl", "<cmd>Gclog! -256 | copen | only<cr>" },
      { "<leader>gp", "<cmd>Git push<cr>" },
      { "<leader>gs", "<cmd>Git | only<cr>" },
    }
  },


  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        on_colors = function(colors)
          -- Set base colors from your Emacs theme
          colors.bg = "#1D1F23"      -- bg
          colors.bg_dark = "#242837" -- bg-alt

          colors.fg = "#EFEFEF"      -- fg
          colors.fg_dark = "#BFC7D5" -- fg-alt
        end,

        on_highlights = function(highlights, colors)
          -- Core syntax elements matching your Emacs theme
          highlights.String = { fg = "#EDCB66" }   -- yellow
          highlights.Function = { fg = "#9DD274" } -- green
          highlights.Keyword = { fg = "#FF7A90" }  -- magenta
          highlights.Constant = { fg = "#BB9CF7" } -- violet
          highlights.Number = { fg = "#f78c6c" }   -- orange
          highlights.Boolean = { fg = "#BB9CF7" }  -- violet (matching constants)
          highlights.Operator = { fg = "#85DAFB" } -- cyan
          highlights.Type = { fg = "#85DAFB" }     -- cyan
          highlights.Variable = { fg = "#85DAFB" } -- cyan
          highlights.Comment = { fg = "#788494" }  -- comment-grey

          -- Add highlighting for variable members/properties
          highlights["@variable.member"] = { fg = "#85DAFB" }  -- cyan
          highlights["@keyword.function"] = { fg = "#FF7A90" } -- magenta
          highlights["@keyword.import"] = { fg = "#FF7A90" }   -- magenta
          highlights["@module"] = { fg = "#85DAFB" }           -- cyan
          highlights["@constant.builtin"] = { fg = "#BB9CF7" } -- purple

          -- Line numbers
          highlights.LineNr = { fg = "#4E5579" }       -- base4
          highlights.CursorLineNr = { fg = "#BFC7D5" } -- fg-alt

          -- Current line highlight
          highlights.CursorLine = { bg = "#242837" } -- bg-alt

          -- Tab line customization
          highlights.TabLine = {
            bg = colors.bg, -- bg
            fg = "#4E5579"  -- base4
          }

          highlights.TabLineSel = {
            bg = "#242837", -- bg-alt for active tab
            fg = colors.fg  -- fg for active tab text
          }

          highlights.TabLineFill = {
            bg = colors.bg, -- bg
          }

          -- Search highlights
          highlights.Search = {
            bg = "#EDCB66", -- yellow
            fg = colors.bg
          }

          highlights.CurSearch = {
            bg = "#f78c6c", -- orange
            fg = colors.bg
          }

          highlights.IncSearch = {
            bg = "#EDCB66", -- yellow
            fg = colors.bg
          }

          -- Spelling highlights
          highlights.SpellBad = {
            bg = "#DD7A90",
            fg = colors.bg,
          }

          highlights.SpellCap = {
            bg = "#EDCB66",
          }

          highlights.SpellRare = {
            bg = "#BB9CF7",
          }

          highlights.SpellLocal = {
            bg = "#85DAFB",
          }

          -- Telescope customization with debug colors
          local telescope_bg = "#1D1F23"     -- bg
          local telescope_border = "#697098" -- base6

          -- Base windows
          highlights.TelescopeNormal = {
            bg = telescope_bg,
            fg = colors.fg,
          }

          highlights.TelescopePromptNormal = {
            bg = telescope_bg,
          }

          -- Try multiple highlight groups for results window
          highlights.TelescopeResults = {
            bg = telescope_bg,
          }

          highlights.TelescopeResultsNormal = {
            bg = telescope_bg,
          }

          highlights.TelescopePromptTitle = {
            bg = telescope_bg,
            fg = telescope_border,
          }

          highlights.TelescopeResultsTitle = {
            bg = telescope_bg,
            fg = telescope_border,
          }

          -- Also try the preview window which might be affecting it
          highlights.TelescopePreviewNormal = {
            bg = telescope_bg,
          }

          highlights.TelescopePreviewTitle = {
            bg = telescope_bg,
            fg = telescope_border,
          }

          -- Selection in results window
          highlights.TelescopeSelection = {
            bg = "#242837",
          }

          highlights.TelescopePromptBorder = {
            bg = telescope_bg,
            fg = telescope_border,
          }

          highlights.TelescopeResultsBorder = {
            bg = telescope_bg,
            fg = telescope_border,
          }
        end
      })

      -- Make sure the color scheme is applied after all customizations
      vim.cmd.colorscheme("tokyonight-moon")
    end
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "junegunn/fzf",                 -- Provide easy installation of fzf binary within Neovim
      "nvim-tree/nvim-web-devicons",  -- optional icons
    },
    keys = {
      { "gd", function() require("fzf-lua").lsp_definitions() end, desc = "Goto LSP definitions using fzf" },
      { "grr", function() require("fzf-lua").lsp_references() end, desc = "Goto LSP references using fzf" },
      { "<leader>t", function() require("fzf-lua").grep({ search = "^ *(class|def) _? -- *.py", no_esc=true, rg_glob=true }) end, desc = "grep/fuzzy-find in project with fzf" },
      { "<leader>f", function() require("fzf-lua").live_grep() end, desc = "(rip)grep in project with fzf" },
      { "<leader>h", function() require("fzf-lua").helptags() end, desc = "Fuzzy search Neovim help topics with fzf" },
      { "<leader>l", function() require('fzf-lua').blines({previewer = false}) end, desc = "Fuzzy find lines in current buffer with fzf" },
      { "<leader>p", function() require("fzf-lua").files() end, desc = "Fuzzy-find files using fzf" },
      { "<leader>r", function() require('fzf-lua').resume() end, desc = "Resume last fzf picker view" },
      { "<leader>b", function() require('fzf-lua').buffers() end, desc = "Fuzzy search open buffers" },
      { "<leader>e", function() require('fzf-lua').diagnostics_document() end, desc = "Show LSP diagnostics for the current buffer" },
    },
  },

  {
    'jpalardy/vim-slime',
    keys = {
      {"g<cr>", "<Plug>SlimeParagraphSend"},
      {"g<cr>", "<Plug>SlimeRegionSend", mode="v" },
    },
    init = function()
      vim.g.slime_no_mappings = 1
      vim.g.slime_target = "tmux"
      vim.g.slime_dont_ask_default = 1
      vim.g.slime_bracketed_paste = 1
      vim.g.slime_default_config = { socket_name = 'default', target_pane = '{last}' }
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require 'nvim-treesitter.configs'.setup {
        indent = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "rust",
          "sql",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require('fidget').setup({
        progress = {
          ignore = { "pylsp" }  -- pylsp has noisy linter notifications
        }
      })
    end
  }

})


----------------------------------------------------------------------------------
--- KEYBINDINGS
----------------------------------------------------------------------------------
vim.keymap.set("i", "<c-f>", "<right>", {})                                  -- Make ctrl-f move one character forward in insert mode.
vim.keymap.set("n", "<leader>W", "<cmd>let @+ = expand(\"%:p\")<cr>", {})    -- Copy the full path to the current file
vim.keymap.set("n", "<leader>w", "<cmd>let @+ = expand(\"%:~:.\")<cr>", {})  -- Copy path to current file, relative to repo root
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", {})                              -- Previous quickfix item
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", {})                              -- Next quickfix item
vim.keymap.set("n", "Y", "yy", {})                                           -- Yank whole line when pressing shift-y
vim.keymap.set("n", "ZA", "<cmd>qa!<cr>", {})                                -- Entirely quit Neovim, discarding all changes, without confirmation
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })              -- Allow pressing Esc in the Neovim terminal to return to normal mode
vim.keymap.set({ "n", "v" }, "<C-j>", "6gj", {})                             -- Move down by 6 lines
vim.keymap.set({ "n", "v" }, "<C-k>", "6gk", {})                             -- Move up by 6 lines

-- Render Markdown output with Pandoc
vim.keymap.set("n", "<leader>mw",
  "<cmd>silent w !pandoc --quiet -c ~/code/toolbag/markdown.css -f 'gfm+hard_line_breaks' -t html5 --mathjax --highlight-style pygments --standalone -o ~/.pandoc_html_output.html - && open ~/.pandoc_html_output.html<cr>",
  {})
