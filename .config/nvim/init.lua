local opt = vim.opt

opt.number = true
opt.termguicolors = true

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

