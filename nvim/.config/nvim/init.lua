require("config.lazy")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
  on_attach = my_on_attach,
})


local tree_api = require "nvim-tree.api"
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>t', tree_api.tree.open, 		      { desc = 'Open Tree' })
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<C-h>', '<C-w>h', {})
vim.keymap.set('n', '<C-j>', '<C-w>j', {})
vim.keymap.set('n', '<C-l>', '<C-w>l', {})
vim.keymap.set('n', '<C-k>', '<C-w>k', {})

vim.cmd.colorscheme("github_dark_default")
vim.cmd.set("smartindent")
vim.cmd.set("number")
vim.cmd.set("mouse=v")

require("nvim-treesitter.configs").setup({
  ensure_installed = { "elixir", "heex", "eex" },
  highlight = { enable = true },
})

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local ls = require("luasnip")

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

        -- For `mini.snippets` users:
        -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
        -- insert({ body = args.body }) -- Insert at cursor
        -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
        -- require("cmp.config").set_onetime({ sources = {} })
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<C-j>'] = cmp.mapping.select_next_item(),
      ['<C-k>'] = cmp.mapping.select_prev_item(),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then           -- меню автокомплита открыто
	  cmp.select_next_item()
          cmp.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        elseif ls.expand_or_jumpable() then
          ls.expand_or_jump()           -- разворачивание/прыжок LuaSnip
        else
          fallback()                    -- обычный Tab
        end
      end, {"i", "s"}),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif ls.jumpable(-1) then
          ls.jump(-1)                  -- LuaSnip назад
        else
          fallback()
        end
      end, {"i", "s"}),
    }),

    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"v"}, "<leader>y", ":w! ~/.vbuf<cr>", {})
vim.keymap.set({"n"}, "<leader>y", ":.w! ~/.vbuf<cr>", {})
vim.keymap.set({"n"}, "<leader>v", ":r ~/.vbuf<cr>", {})

vim.keymap.set({"i"}, "<C-l>", "<C-o>:nohlsearch<cr>", {})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

-- vim.keymap.set({"n"}, "<leader>C-space", "gcc", {})

require("luasnip").config.setup({
  history = true,
  enable_autosnippets = true,
})


local lspconfig = require("lspconfig")
local util      = require("lspconfig.util")
local augroup   = vim.api.nvim_create_augroup("LspFormat", {})

lspconfig.elixirls.setup({
  cmd = { "/opt/homebrew/bin/elixir-ls" },   -- путь к бинарю
  filetypes = { "elixir", "heex", "surface" },   -- по умолчанию тоже ок
  root_dir = util.root_pattern("mix.exs", ".git"),
  settings = {
    elixirLS = {
      dialyzerEnabled = true,
      fetchDeps       = false,
    },
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group   = augroup,
        buffer  = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 4000 })
        end,
      })
    end
  end,
})
