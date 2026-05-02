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
vim.g.loaded_python3_provider = 0     -- Disable unused Python provider (used for extensions written with Python)
vim.g.loaded_perl_provider    = 0     -- Disable unused Perl provider (used for extensions written with Perl)
vim.g.loaded_ruby_provider    = 0     -- Disable unused Ruby provider (used for extensions written with Ruby)
vim.g.loaded_node_provider    = 0     -- Disable unused Node provider (used for extensions written with Node)
vim.opt.backup                = false -- No backup file, part 1
vim.opt.writebackup           = false -- No backup file, part 2
vim.opt.shada                 = ""    -- No ShaDa (Shared Data) file
vim.opt.swapfile              = false -- Don't write swapfiles
vim.opt.undofile              = false -- Don't write an undofile

-- Add a jump to the jumplist via m' when using k with a count
vim.keymap.set('n', 'k', function()
  return (vim.v.count > 1 and "m'" .. vim.v.count or '') .. 'k'
end, { expr = true, noremap = true })

-- Add a jump to the jumplist via m' when using j with a count
vim.keymap.set('n', 'j', function()
  return (vim.v.count > 1 and "m'" .. vim.v.count or '') .. 'j'
end, { expr = true, noremap = true })


----------------------------------------------------------------------------------
--- OPTIONS
----------------------------------------------------------------------------------
vim.opt.laststatus = 0                                -- Don't show the statusline
vim.opt.showmode = false                              -- Don't show the mode in the message area
vim.opt.ruler = false                                 -- Don't show line,col or position in file
vim.opt.shortmess:append("I")                         -- Don't show the intro screen

vim.opt.clipboard:append { "unnamed", "unnamedplus" } -- Use system clipboard by default

vim.opt.hlsearch = true                               -- Highlight matches while searching
vim.opt.ignorecase = true                             -- Ignore case while searching, by default
vim.opt.incsearch = true                              -- Enable incremental search by default
vim.opt.smartcase = true                              -- Smart case search: Care about case only if one or more uppercase letters are present

vim.opt.expandtab = true                              -- Use spaces by default instead of tabs
vim.opt.tabstop = 4                                   -- How wide a tab looks when displayed
vim.opt.shiftwidth = 4                                -- How many spaces to indent by
vim.opt.softtabstop = 4                               -- How many spaces to insert when pressing TAB

vim.opt.number = true                                 -- Enable line numbers
vim.opt.rnu = true                                    -- Make the line numbers relative

vim.opt.wrap = true                                   -- Soft-wrapping of lines
vim.opt.linebreak = true                              -- Wrap lines at whole words, not individual characters

vim.g.mapleader = " "                                 -- Set space as the leader key


----------------------------------------------------------------------------------
--- AUTOCMDS
----------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufReadCmd', { pattern = '*.whl', command = 'call zip#Browse(expand("<amatch>"))' }) -- Browse .whl files like .zip
vim.api.nvim_create_autocmd('BufWritePre', { pattern = '', command = ":%s/\\s\\+$//e" })                          -- Delete trailing spaces on save


----------------------------------------------------------------------------------
--- PLUGINS
----------------------------------------------------------------------------------
require("lazy").setup({
  { "cohama/lexima.vim" },               -- Auto-pairing of characters
  { "michaeljsmith/vim-indent-object" }, -- Indentation as a vim text object
  { "scrooloose/nerdtree" },             -- Nerdtree: Sidebar for browsing files

  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    lazy = false, -- Or else you can't do `:e .` and have it load Oil
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
      { "<leader>gf", "<cmd>Git fullup<cr>" },
      { "<leader>gh", "<cmd>Gclog! -256 % | copen | only<cr>" },
      { "<leader>gl", "<cmd>Gclog! -256 | copen | only<cr>" },
      { "<leader>gp", "<cmd>Git push<cr>" },
      { "<leader>gs", "<cmd>Git | only<cr>" },
    }
  },


  {
    "folke/tokyonight.nvim",
    lazy = false,    -- We want the theme to be immediately available!
    priority = 1000, -- Load the theme before any other plugins
    config = function()
      require("tokyonight").setup({
        on_colors = function(colors)
          -- Set base colors from your Emacs theme
          colors.bg = "#1a120e"
          colors.bg_dark = "#432A1E"

          colors.fg = "#F0DFD8"
          colors.fg_dark = "#D7C2BA"

          colors.comment_grey = "#7C7C7C"
          colors.cyan = "#9EC3C4"
          colors.dark_grey = "#4C4C4C"
          colors.green = "#9EC49F"
          colors.magenta = "#FFB4AB"
          colors.orange = "#FFB694"
          colors.purple = "#C49EC4"
          colors.violet = "#A39EC4"
          colors.yellow = "#C4C19E"
        end,

        on_highlights = function(highlights, colors)
          highlights.String = { fg = colors.yellow }
          highlights.Function = { fg = colors.green }
          highlights.Keyword = { fg = colors.magenta }
          highlights.Constant = { fg = colors.violet }
          highlights.Number = { fg = colors.orange }
          highlights.Boolean = { fg = colors.violet }
          highlights.Operator = { fg = colors.cyan }
          highlights.Type = { fg = colors.orange }
          highlights.Variable = { fg = colors.orange }
          highlights.Comment = { fg = colors.comment_grey }
          highlights.StatusLine = { fg = colors.fg_dark }

          highlights["@variable.member"] = { fg = colors.orange }
          highlights["@keyword.function"] = { fg = colors.magenta }
          highlights["@keyword.import"] = { fg = colors.magenta }
          highlights["@module"] = { fg = colors.orange }
          highlights["@constant.builtin"] = { fg = colors.purple }

          highlights.LineNr = { fg = colors.fg_dark }
          highlights.LineNrAbove = { fg = colors.dark_grey }
          highlights.LineNrBelow = { fg = colors.dark_grey }
          highlights.CursorLineNr = { fg = colors.fg_dark }

          highlights.CursorLine = { bg = colors.bg }

          highlights.TabLine = {
            bg = colors.bg,
            fg = colors.dark_grey
          }

          highlights.TabLineSel = {
            bg = colors.bg,
            fg = colors.fg
          }

          highlights.TabLineFill = {
            bg = colors.bg,
          }

          highlights.Search = {
            bg = colors.yellow,
            fg = colors.bg
          }

          highlights.CurSearch = {
            bg = colors.orange,
            fg = colors.bg
          }

          highlights.IncSearch = {
            bg = colors.yellow,
            fg = colors.bg
          }

          highlights.SpellBad = {
            bg = colors.magenta,
            fg = colors.bg,
          }

          highlights.SpellCap = {
            bg = colors.yellow,
          }

          highlights.SpellRare = {
            bg = colors.cyan,
          }

          highlights.SpellLocal = {
            bg = colors.purple,
          }
        end
      })

      -- Load theme only after all customizations have been made
      vim.cmd.colorscheme("tokyonight-moon")
    end
  },

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "junegunn/fzf",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          preview = {
            layout = "vertical", -- Results/preview panes over/under, rather than side-by-side.
          },
        },
        keymap = {
          fzf = {
            ["ctrl-q"] = "select-all+accept",
          }
        },
        grep = {
          hidden = true,
          rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e]],
        },
      })
    end,
    keys = {
      { "gd",  function() require("fzf-lua").lsp_definitions() end, desc = "Goto LSP definitions using fzf" },
      { "grr", function() require("fzf-lua").lsp_references() end,  desc = "Goto LSP references using fzf" },
      {
        "<leader>f",
        function()
          require("fzf-lua").live_grep({
            -- PCRE zero-length lookaheads allow us to do an orderless regex search:
            --
            -- We'll split on spaces so that each space-delimited term is a
            -- self-contained regex, and then each regex can occur in any
            -- order.
            --
            -- Example:
            --     The search term "foo bar" becomes the command `rg -P '^(?=.*foo)(?=.*bar)'`
            --
            fn_transform_cmd = function(query, cmd, _)
              if not cmd then return end
              if query and #query > 0 then
                local lookaheads = ""
                for term in query:gmatch("%S+") do
                  lookaheads = lookaheads .. "(?=.*" .. term .. ")"
                end
                return cmd .. "'^" .. lookaheads .. "'"
              end
              return cmd .. query
            end,
            rg_opts =
            [[--column --line-number --no-heading --color=always --smart-case -P --max-columns=4096 -g "!.git" -e]],
          })
        end,
        desc = "Orderless ripgrep in project with fzf"
      },
      { "<leader>h", function() require("fzf-lua").helptags() end,                    desc = "Fuzzy search Neovim help topics with fzf" },
      { "<leader>l", function() require('fzf-lua').blines({ previewer = false }) end, desc = "Fuzzy find lines in current buffer with fzf" },
      { "<leader>p", function() require("fzf-lua").files() end,                       desc = "Fuzzy-find files using fzf" },
      { "<leader>r", function() require('fzf-lua').resume() end,                      desc = "Resume last fzf picker view" },
      { "<leader>b", function() require('fzf-lua').buffers() end,                     desc = "Fuzzy search open buffers" },
      { "<leader>e", function() require('fzf-lua').diagnostics_document() end,        desc = "Show LSP diagnostics for the current buffer" },
      {
        "<leader>t",
        function()
          require("fzf-lua").live_grep({
            -- The structural pattern (matching class/function definitions) is fixed and
            -- non-orderless. Any additional terms the user types are applied as orderless
            -- PCRE lookaheads, so e.g. typing "my_func" narrows results to definitions
            -- whose line also contains "my_func", in any position.
            --
            -- Example: typing "foo bar" matches lines that:
            --   1. Look like a class/function definition (structural pattern)
            --   2. Also contain both "foo" AND "bar" anywhere on the line (in any order)
            --
            -- NOTE: fn_transform_cmd runs in a headless Neovim process with no upvalue
            -- access, so the structural pattern must be inlined rather than captured from
            -- the outer scope.
            fn_transform_cmd = function(query, cmd, _)
              if not cmd then return end
              local struct = "^ *(async )?(class|\\(?def(un)?|fu?n(c|ction)?) _?"
              local lookaheads
              if query and #query > 0 then
                local leading_space = query:sub(1, 1) == " "
                local terms = {}
                for term in query:gmatch("%S+") do
                  table.insert(terms, term)
                end
                if leading_space then
                  -- All terms orderless; structural pattern stands alone
                  lookaheads = "(?=.*" .. struct .. ")"
                  for _, term in ipairs(terms) do
                    lookaheads = lookaheads .. "(?=.*" .. term .. ")"
                  end
                else
                  -- First term appended directly onto structural pattern; rest are orderless
                  lookaheads = "(?=.*" .. struct .. terms[1] .. ")"
                  for i = 2, #terms do
                    lookaheads = lookaheads .. "(?=.*" .. terms[i] .. ")"
                  end
                end
              else
                lookaheads = "(?=.*" .. struct .. ")"
              end
              return cmd .. "'^" .. lookaheads .. "'"
            end,
            rg_opts = [[--column --line-number --no-heading --color=always --smart-case -P --max-columns=4096 -g "!.git" -e]],
          })
        end,
        desc = "Fuzzy-find class/function definitions in project with fzf"
      },
    },
  },

  {
    'jpalardy/vim-slime',
    keys = {
      { "<leader><cr>", "<Plug>SlimeParagraphSend" },
      { "<leader><cr>", "<Plug>SlimeRegionSend",   mode = "v" },
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
    lazy = false, -- Or it won't attach an LSP server and start indexing when you open a file
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    keys = {
      { "<f2>", "<cmd>lua vim.lsp.buf.rename()<cr>" },
      { "[d",   "<cmd>lua vim.diagnostic.goto_prev()<cr>" },
      { "]d",   "<cmd>lua vim.diagnostic.goto_next()<cr>" },
      { "K",    "<cmd>lua vim.lsp.buf.hover()<cr>" },
    },
  },

  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide: brew install tree-sitter-cli
    config = function()
      require("tree-sitter-manager").setup({
        ensure_installed = {
          "bash",
          "c",
          "dockerfile",
          "javascript",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "rust",
          "sql",
          "toml",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true, -- Auto-install parsers when editing a file that doesn't have a parser already installed.
      })
    end
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require 'treesitter-context'.setup({
        enable = true,
        line_numbers = true,
        max_lines = 5,
        min_window_height = 0,
        mode = 'cursor',
        multiline_threshold = 20,
        on_attach = nil,
        separator = "-",
        trim_scope = 'outer',
        zindex = 20,
      })
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "None" })
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "LineNr" })
    end
  },

  {
    "j-hui/fidget.nvim",
    config = function()
      require('fidget').setup({
        progress = {
          ignore = { "pylsp" } -- pylsp has noisy linter notifications
        }
      })
    end
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        -- Use `:help formatters` to see a list of builtin formatters
        formatters_by_ft = {
          go = { "gofmt" },
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
          terraform = { "tofu_fmt" },
        },
        format_on_save = {
          async = false,
          lsp_fallback = true,
          timeout_ms = 1000,
        },
      })
    end,
  },

  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>a", function() require("aerial").fzf_lua_picker() end }
    },
    config = function()
      require("aerial").setup({
        -- Use treesitter as the sole backend for maximum speed
        backends = { "treesitter" },
      })
    end
  },

  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      keymap = {
        preset = 'super-tab',
        ['<C-f>'] = {}, -- Disable Blink's <C-f> mapping. I use it to move one char forward in Insert mode.
      },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        accept = {
          auto_brackets = { enabled = false },
        },
        documentation = { auto_show = true },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",         -- Nice UI for interfacing with the debugger
      "nvim-neotest/nvim-nio",        -- Required for nvim-dap-ui
      "leoluz/nvim-dap-go",           -- Debugger configuration for Golang
      "mfussenegger/nvim-dap-python", -- Debugger configuration for Python
    },
    config = function()
      require("dapui").setup()

      -- Python-specific configuration
      require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
      require('dap-python').test_runner = 'pytest'
      require("dap").configurations.python = {
        {
          console = "integratedTerminal",
          justMyCode = false,
          name = "Launch file",
          program = "${file}",
          request = "launch",
          type = "python",
        }
      }

      -- Auto-open/close DAP UI
      require("dap").listeners.after.event_initialized["dapui_config"] = function()
        require("dapui").open()
      end
      require("dap").listeners.before.event_terminated["dapui_config"] = function()
        require("dapui").close()
      end
      require("dap").listeners.before.event_exited["dapui_config"] = function()
        require("dapui").close()
      end
    end,

    -- Key mappings (optional)
    keys = {
      { '<leader>dn',       function() require("dap").step_over() end },
      { '<leader>di',       function() require("dap").step_into() end },
      { '<leader>do',       function() require("dap").step_out() end },
      { '<leader>db',       function() require("dap").toggle_breakpoint() end },
      { '<leader>dc',       function() require("dap").toggle_breakpoint(vim.fn.input('Breakpoint condition: ')) end },
      { '<leader>d<bs>',    function() require("dap").clear_breakpoints() end },
      { '<leader>d<tab>',   function() require("dapui").toggle({ reset = true }) end },
      { '<leader>d<enter>', function() require("dap").run_to_cursor() end },
      { '<leader>d<esc>',   function() require("dap").terminate() end },
      { '<leader>dd',       function() require("dap").continue() end },
      { '<leader>dk',       function() require("dapui").eval() end,                                                 mode = { "n", "v" } },
      { '<leader>dp',       function() require("dap").pause() end },
      { '<leader>dr',       function() require("dap").repl.toggle() end },

      { '<leader>dt',       function() require('dap-python').test_method({ config = { justMyCode = false } }) end,  ft = "python" },
      { '<leader>dt',       function() require('dap-go').debug_test() end,                                          ft = "go" },

      { '<leader>dw',       function() require("dapui").elements.watches.add() end },
    }
  },

})


----------------------------------------------------------------------------------
--- ADDITIONAL LSP CONFIGURATION
----------------------------------------------------------------------------------
vim.lsp.config('ty', { settings = { ['ty'] = { experimental = { rename = true } } } })
vim.lsp.config('*', {
  on_attach = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})


----------------------------------------------------------------------------------
--- KEYBINDINGS
----------------------------------------------------------------------------------
vim.keymap.set("i", "<c-f>", "<right>", {})                                 -- Make ctrl-f move one character forward in insert mode
vim.keymap.set("n", "<leader>W", "<cmd>let @+ = expand(\"%:p\")<cr>", {})   -- Copy the full path to the current file
vim.keymap.set("n", "<leader>w", "<cmd>let @+ = expand(\"%:~:.\")<cr>", {}) -- Copy path to current file, relative to repo root
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", {})                             -- Previous quickfix item
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", {})                             -- Next quickfix item
vim.keymap.set("n", "Y", "yy", {})                                          -- Yank whole line when pressing shift-y
vim.keymap.set("n", "ZA", "<cmd>qa!<cr>", {})                               -- Entirely quit Neovim, discarding all changes, without confirmation
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })             -- Allow pressing Esc in the Neovim terminal to return to normal mode
vim.keymap.set({ "n", "v" }, "<C-j>", "6gj", {})                            -- Move down by 6 lines
vim.keymap.set({ "n", "v" }, "<C-k>", "6gk", {})                            -- Move up by 6 lines


---------------------------------------------------------------------------------
-- Open a terminal in a side split, in the same directory as the current buffer
---------------------------------------------------------------------------------
vim.keymap.set('n', '<leader>`', function()
  local dir = require("oil").get_current_dir() or vim.fn.expand('%:p:h')
  local shell = vim.fn.has('win32') == 1 and 'powershell' or ''
  if string.match(dir, "fugitive://") then
    vim.cmd('vsplit | wincmd w | terminal ' .. shell)
  else
    vim.cmd('vsplit | wincmd w | lcd ' .. vim.fn.fnameescape(dir) .. ' | terminal ' .. shell)
  end
  vim.cmd('startinsert')
end, { desc = "Open a terminal in a side split, in the same directory as the current buffer" })


---------------------------------------------------------------------------------
-- Render either the whole buffer or the current visual selection as Markdown
-- with Pandoc
---------------------------------------------------------------------------------
local function render_markdown_with_pandoc(start_line, end_line)
  start_line = start_line or 1
  end_line = end_line or vim.fn.line("$")
  local range = start_line .. "," .. end_line
  local css = vim.fn.stdpath("config") .. "/assets/markdown.css"
  local cmd = string.format(
    "silent %sw !pandoc --quiet -c %s -f 'gfm+hard_line_breaks' -t html5 --mathjax --highlight-style pygments --standalone -o ~/.pandoc_html_output.html - && open ~/.pandoc_html_output.html",
    range,
    vim.fn.shellescape(css)
  )
  vim.cmd(cmd)
end

vim.keymap.set("n", "<leader>mw", function()
  render_markdown_with_pandoc()
end, { desc = "Export Markdown to HTML with Pandoc" })

vim.keymap.set("v", "<leader>mw", function()
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  render_markdown_with_pandoc(start_line, end_line)
end, { desc = "Export selected Markdown lines to HTML with Pandoc" })


---------------------------------------------------------------------------------
-- Open permalink for current file/line number on GitHub
---------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>go", function()
  local remote = vim.trim(vim.fn.system("git remote get-url origin"))
  local commit = vim.trim(vim.fn.system("git rev-parse HEAD"))
  local file = vim.fn.expand("%:~:.")
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local parts = {}
  for part in remote:gmatch("[^/:]+") do
    table.insert(parts, part)
  end
  local repo = parts[#parts - 1] .. "/" .. parts[#parts]:gsub("%.git$", "")
  local url = string.format("https://github.com/%s/blob/%s/%s#L%d", repo, commit, file, line)

  local open_cmd = vim.fn.has('mac') == 1 and 'open' or 'xdg-open'
  vim.fn.system(open_cmd .. " " .. vim.fn.shellescape(url))
end)


---------------------------------------------------------------------------------
-- Stupid hack to make the message area not continue displaying a message if
-- I'm done looking at it. Might delete later.
---------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    vim.cmd("echo ''")
  end,
})
