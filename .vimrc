set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'Shougo/neomru.vim'
Bundle 'Shougo/unite.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'Shougo/neocomplcache'
Bundle 'snipMate'
Bundle 'ZenCoding.vim'
Bundle 'quickrun.vim'
Bundle 'surround.vim'
"Bundle 'jslint.vim'
Bundle 'ref.vim'
"Bundle 'git://github.com/vim-scripts/errormarker.vim.git'
Bundle 'git://github.com/mattn/gist-vim.git'
Bundle 'git://github.com/mattn/webapi-vim.git'
Bundle 'git://github.com/vim-scripts/yaml.vim.git'
Bundle 'git://github.com/tpope/vim-markdown.git'
Bundle 'git://github.com/mattn/mkdpreview-vim.git'
Bundle 'git://github.com/nanotech/jellybeans.vim.git'
Bundle 'buftabs'
Bundle 'vim-coffee-script'
Bundle 'https://github.com/pekepeke/titanium-vim.git'
"Bundle 'fugitive.vim'
Bundle 'migrs/qfixhowm'
Bundle 'git@github.com:itchyny/calendar.vim.git'
Bundle 'itchyny/lightline.vim'
Bundle 'scrooloose/syntastic.git'
Bundle 'nosami/Omnisharp.git'
Bundle 'tpope/vim-dispatch.git'
Bundle 'vim-scripts/AutoComplPop.git'
Bundle 'dtjm/plantuml-syntax.vim.git'
Bundle 'tpope/vim-fugitive'
Bundle 'git@github.com:tomasr/molokai.git'
Bundle 'git@github.com:slim-template/vim-slim.git'


" vim: :set ts=4 sw=4 sts=0:
"-----------------------------------------------------------------------------
" 文字コード関連
"
let mapleader = ","
if &encoding !=# 'utf-8'
	:set encoding=japan
	:set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconvがeucJP-msに対応しているかをチェック
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconvがJISX0213に対応しているかをチェック
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodingsを構築
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		:set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			:set fileencodings+=cp932
			:set fileencodings-=euc-jp
			:set fileencodings-=euc-jisx0213
			:set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" 定数を処分
	unlet s:enc_euc
	unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
	autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
:set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
	:set ambiwidth=double
endif
:set fileencodings=iso-2022-jp,utf-8,cp932,euc-jp,default,latin

"-----------------------------------------------------------------------------
" 編集関連
"
"オートインデントする
:set autoindent
" ックスペースでインデントや改行を削除できるようにする。　
set backspace=2
set mouse-=a
set showcmd
set cmdheight=2
set wildmenu


"バイナリ編集(xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
	autocmd!
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * :set ft=xxd | endif
	autocmd BufWritePre * if &binary | %!xxd -r | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * :set nomod | endif
augroup END

:set ruler 
"折り畳み設定
syntax on
"let javaScript_fold = 1 
"let javaScript_fold_blocks=1
set foldlevel=0
set foldmethod=syntax
"let perl_fold=1
"let perl_fold_blocks=1
vmap t !perltidy<CR>

let $JS_CMD = 'node'

"-----------------------------------------------------------------------------
" 検索関連
"
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
"検索文字列に大文字が含まれている場合は区別して検索する
:set smartcase
"検索時に最後まで行ったら最初に戻る
:set wrapscan
"検索文字列入力時に順次対象文字列にヒットさせない
:set noincsearch

"-----------------------------------------------------------------------------
" 装飾関連
"
"シンタックスハイライトを有効にする
if has("syntax")
	syntax on
endif
"行番号を表示しない
:set number
"タブの左側にカーソル表示
:set listchars=tab:._ 
:set list
"タブ幅を設定する
:set tabstop=4
autocmd FileType ruby setl ts=2
:set expandtab
:set shiftwidth=4
autocmd FileType ruby setl shiftwidth=2
"入力中のコマンドをステータスに表示する
:set showcmd
"括弧入力時の対応する括弧を表示
:set showmatch
"検索結果文字列のハイライトを有効にする
:set hlsearch
"ステータスラインを常に表示
:set laststatus=2
"ステータスラインに文字コードと改行文字を表示する
:set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

"行頭のスペースの連続をハイライトさせる
"Tab文字も区別されずにハイライトされるので、区別したいときはTab文字の表示を別に
"設定する必要がある。
"function! SOLSpaceHilight()
"    syntax match SOLSpace "^\s\+" display containedin=ALL
"    highlight SOLSpace term=underline ctermbg=LightGray
"endf
"全角スペースをハイライトさせる。
function! JISX0208SpaceHilight()
    syntax match JISX0208Space "　" display containedin=ALL
    highlight JISX0208Space term=underline ctermbg=LightCyan
endf
"syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
    syntax on
        augroup invisible
        autocmd! invisible
        "autocmd BufNew,BufRead * call SOLSpaceHilight()
        autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    augroup END
endif

"ファイルタイプの設定
au BufRead,BufNewFile *.tt set filetype=html

"行末のスペースを目立たせる。
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/
autocmd WinEnter * match WhitespaceEOL /\s\+$/

"-----------------------------------------------------------------------------
" マップ定義
"
"バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>
"表示行単位で行移動する
nnoremap j gj
nnoremap k gk
"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

"括弧を自動で
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"inoremap < <><LEFT>
noremap <Space>c \c<Space>

noremap <Space>q :%QuickRun<Return>

"plugin
filetype on
filetype plugin on
filetype indent on
"-------------------------------------

"function InsertTabWrapper()
    "if pumvisible()
        "return "\<c-n>"
    "endif
    "let col = col('.') - 1
    "if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        "return "\<tab>"
    "elseif exists('&omnifunc') && &omnifunc == ''
        "return "\<c-n>"
    "else
        "return "\<c-x>\<c-o>"
    "endif
"endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"nnoremap <expr> h foldlevel(getpos('.')[1])>0 &&
	"\(getpos('.')[2]==1 \|\|
	"\getline('.')[: getpos('.')[2]-2] =~"^[\<TAB>]*$")?"zch":"h"
source ~/.vimrc.local

"---------------------------------------------------------------------
" for termunite.vim
"---------------------------------------------------------------------
nnoremap <silent> <Space>uu :Unite -buffer-name=files -auto-preview file<CR>
nnoremap <silent> <Space>uf :Unite -buffer-name=file -auto-preview file_mru<CR>
nnoremap <silent> <Space>ur :Unite file_rec<CR>
nnoremap <silent> <Space>uc :UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Space>ut :Unite tab<CR>
nnoremap <silent> <Space>uy :Unite register<CR>
nnoremap <silent> <Space>ua :UniteBookmarkAdd<CR>
nnoremap <silent> <Space>ub :Unite bookmark<CR>
nnoremap <silent> <Space>ui :Unite file_include<CR>

"autocmd FileType unite call s:unite_my_settings()
"function! s:unite_my_settings()"{{{
  "nnoremap <silent><buffer> <C-o> :call unite#mappings#do_action('tabopen')<CR>
  "inoremap <silent><buffer> <C-o> <Esc>:call unite#mappings#do_action('tabopen')<CR>

  "call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
  "call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

  "call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  "call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
  "call unite#set_substitute_pattern('file', '^\\', '~/*')

  "call unite#set_substitute_pattern('file', '\*\*\+', '*', -1)

  "call unite#set_substitute_pattern('file', '\\\@<! ', '\\ ', -20)
  "call unite#set_substitute_pattern('file', '\\ \@!', '/', -30)
  "let g:unite_enable_ignore_case = 1
  "let g:unite_enable_smart_case = 1
"endfunction"}}}



"---------------------------------------------------------------------
" for neocomplcache.vim
"---------------------------------------------------------------------

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" for snippets
imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-k>"
smap <C-k> <Plug>(neocomplcache_snippets_expand)
let g:neocomplcache_snippets_dir = "~/.vim/snippets"

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> pumvisible() ? neocomplcache#close_popup()."\<C-h>" : "\<C-h>"
inoremap <expr><BS> pumvisible() ? neocomplcache#close_popup()."\<C-h>" : "\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1
inoremap <expr><C-h> pumvisible() ? neocomplcache#cancel_popup()."\<C-h>" : "\<C-h>"
inoremap <expr><BS> pumvisible() ? neocomplcache#cancel_popup()."\<C-h>" : "\<C-h>"

if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"autocmd FileType json set filetype = json
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
command! -bar -bang -nargs=? -complete=file GScouter
\        echo Scouter(empty(<q-args>) ? $MYGVIMRC : expand(<q-args>), <bang>0)

let g:github_user = 'sukesan1984'
let g:gist_put_url_to_clipboard_after_post = 1

"qfixhowm config
let QFixHowm_HowmMode = 0
let QFixHowm_Title    = '#'
let suffix            = 'mkd'
"let QFixHowm_UserFileType = 'howm_memo.markdown'
let QFixHowm_UserFileExt  = suffix
"let QFixHowm_Folding = 0
let QFixHowm_FoldingPattern = '^\d[=.*[]#'

let howm_filename         = '%Y/%m/%Y-%m-%d-%H%M%S.'.suffix
let QFixHowm_FileType='howm_memo.markdown'

"yaml setting
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/bundle/yaml.vim/colors/yaml.vim

"matchit.vim"
source $VIMRUNTIME/macros/matchit.vim
let b:match_words = '\(\<IF\>\|\<UNLESS\>\|\<FOR\>\|\<FOREACH\>\):END,<:>,[:],(:),{:},<div.*>:</div>'

"calendar.vim"
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
nnoremap <silent> <Space>cd :Calendar -view=day -split=vertical -width=30<CR>

"lightline.vim"
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'right': [ [ 'syntastic', 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag'
      \ },
      \ 'component_type': {
      \   'syntastic': 'error'
      \ }
      \ }
let g:syntastic_mode_map = {'mode': 'passive'}
augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.pl,*.rb,*.js call s:syntastic()
augroup END
function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction

"tabの設定"

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
"

" OmniSharp
setlocal omnifunc=syntaxcomplete#Complete
nnoremap <silent> <buffer> ma :OmniSharpAddToProject<CR>
nnoremap <silent> <buffer> mb :OmniSharpBuild<CR>
nnoremap <silent> <buffer> mc :OmniSharpFindSyntaxErrors<CR>
nnoremap <silent> <buffer> mf :OmniSharpCodeFormat<CR>
nnoremap <silent> <buffer> mj :OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> <C-w>mj <C-w>s:OmniSharpGotoDefinition<CR>
nnoremap <silent> <buffer> mi :OmniSharpFindImplementations<CR>
nnoremap <silent> <buffer> mr :OmniSharpRename<CR>
nnoremap <silent> <buffer> mt :OmniSharpTypeLookup<CR>
nnoremap <silent> <buffer> mu :OmniSharpFindUsages<CR>
nnoremap <silent> <buffer> mx :OmniSharpGetCodeActions<CR>

"補完の色
hi Pmenu ctermbg=0
hi PmenuSel ctermbg=4
hi PmenuSbar ctermbg=2
hi PmenuThumb ctermfg=3

"カラースキーマを設定
colorscheme molokai
syntax on
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark

"行末のスペースをHighlightする
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

"Go
call plug#begin()
  Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
  Plug 'AndrewRadev/splitjoin.vim'
  Plug 'ctrlpvim/ctrlp.vim'
call plug#end()
set autowrite
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file=~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>i <Plug>(go-info)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

"Buffer
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

