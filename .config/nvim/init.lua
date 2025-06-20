local opt = vim.opt

opt.number = true
opt.termguicolors = true

-- colorscheme設定
vim.cmd('colorscheme tokyonight')

-- キーマッピング
vim.keymap.set('n', '<C-j>', ':bprev<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', ':bnext<CR>', { silent = true })

-- リーダーキー設定
vim.g.mapleader = ","

-- タイムアウト設定
vim.opt.timeout = true
vim.opt.ttimeoutlen = 50


-- ファイルタイプ設定
vim.cmd('filetype plugin indent on')
vim.cmd('syntax enable')

-- その他の設定
vim.opt.autochdir = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.softtabstop = 0

-- autocmd設定
local augroup = vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = 'vue',
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
  end
})

-- FZF設定
vim.keymap.set('n', '<C-p>', ':History<CR>', { silent = true })
vim.keymap.set('n', '<C-g>', ':Rg<CR>', { silent = true })


-- nvim-tree
require('nvim-tree').setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
vim.keymap.set('n', '<Leader>f', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<C-q>', ':NvimTreeToggle<CR>', { silent = true })

-- 追加の便利なキーマップ
vim.keymap.set('n', '<Leader>tf', ':NvimTreeFindFile<CR>', { silent = true })
vim.keymap.set('n', '<Leader>tr', ':NvimTreeRefresh<CR>', { silent = true })

-- LSP設定
local lspconfig = require('lspconfig')

-- 補完設定
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

-- LSP capabilities設定
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Pyright設定
lspconfig.pyright.setup{
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = ".venv/bin/python",
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
      }
    }
  },
  on_attach = function(client, bufnr)
    -- LSP semantic tokensを有効化
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens.start(bufnr, client.id)
    end
  end,
}

-- Ruff LSP設定（import整理、linting）
lspconfig.ruff.setup{
  capabilities = capabilities,
}

-- LSP診断設定
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- LSP キーマッピング
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Show references' })

-- 診断関連のキーマッピング
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Python specific keymaps
vim.keymap.set('n', '<leader>oi', function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true
  })
end, { desc = 'Organize imports' })

