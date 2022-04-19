set number
set termguicolors
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>


let g:python_host_prog = $HOME . '/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python'
let g:ruby_host_prog = $HOME . '/.rbenv/versions/2.7.1/bin/neovim-ruby-host'

"dein.vim
if &compatible
  set nocompatible
endif
" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
" set runtimepath+=~/.cache/dein/repos/github.com/joshdick/onedark.vim

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif

"colorscheme onedark

filetype plugin indent on
syntax enable
set autochdir

set autoindent "自動インデント
set tabstop=4 "タブ幅
set shiftwidth=4 "自動インデント幅
set noexpandtab "タブをスペースに展開しない
set softtabstop=0 "タブ幅(入力時)
