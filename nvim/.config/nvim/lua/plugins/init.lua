return {
  'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' },

  "L3MON4D3/LuaSnip", build = "make install_jsregexp", dependencies = { "rafamadriz/friendly-snippets" },

  "saadparwaiz1/cmp_luasnip",

  "rafamadriz/friendly-snippets",

  'neovim/nvim-lspconfig',
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("lsp.elixir")   -- код выше
    end,

  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',

  'windwp/nvim-autopairs', event = "InsertEnter", opts = {},

  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,

  "nvim-tree/nvim-web-devicons", opts = {},

  "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate", 

  "elixir-tools/elixir-tools.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local elixir = require("elixir")
    local elixirls = require("elixir.elixirls")

    elixir.setup {
      nextls = {enable = true},
      elixirls = {
        enable = true,
        settings = elixirls.settings {
          dialyzerEnabled = false,
          enableTestLenses = false,
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end,
      },
      projectionist = {
        enable = true
      }
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  'projekt0n/github-nvim-theme', name = 'github-theme',
  "numToStr/Comment.nvim", lazy = false,
}
