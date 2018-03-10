"------------------------------------
"Starup setting
"------------------------------------
"Start with big size window
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=999 columns=999
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif
"------------------------------------
"Startup Setting
"------------------------------------

"------------------------------------
"Neo Bundle Setting
"------------------------------------
" neobundle
"This should be written before whichwrap
set nocompatible               " Be iMproved

filetype off                   " Required!

if has('vim_starting')
    "For Neo-Bundle"
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('$HOME/.vim/bundle/'))

"Writing plugins here
NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'mattn/calendar-vim'
NeoBundle 'taku-o/vim-toggle'
"NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Rip-Rip/clang_complete'

"GitHub flavored markdown
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'superbrothers/vim-quickrun-markdown-gfm'

"Octave
NeoBundle 'vim-scripts/octave.vim--'

"Rust
NeoBundle 'rust-lang/rust.vim'

"Plugins without repositories
if has("win32")
    NeoBundle 'fuenor/im_control.vim'
endif


filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
                \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
    "finish
endif

call neobundle#end()
"------------------------------------
"End Neo Bundle Setting
"------------------------------------

"------------------------------------
"Status Line Setting
"------------------------------------
set laststatus=2
set showtabline=2 "Show always tabline

"------------------------------------
"Status Line Setting
"------------------------------------
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

"------------------------------------
"Vim filer setting
"------------------------------------
let g:vimfiler_as_default_explorer  = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_enable_auto_cd = 1

"------------------------------------
"IM-Control Setting
"------------------------------------
if has("win32")
    set runtimepath+=$HOME\.vim\bundle\im_control.vim\plugin
    if has('gui_running')
      "Fix japanese mode
      let IM_CtrlMode = 4
      "Fix japanese mode key
      inoremap <silent> <C-u> <C-^><C-r>=IMState('FixMode')<CR>
    else
      "Non GUI-environment
      let IM_CtrlMode = 0
    endif
    "Show Japanese-Fix mode
    set statusline+=%{IMStatus('[Japanese-Fixed]')}

"    Dummy function for not showing error messages
"    when im_control.vim does not exists
"    function! IMStatus(...)
"      return ''
"    endfunction
endif

"------------------------------------
"Preferences
"------------------------------------
""Auto encoding discrimination
"{{{
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  "check if iconv is compatible with eucJP-ms
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  "check if iconv is compatible with JISX0213
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodings
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  "remove constant
  unlet s:enc_euc
  unlet s:enc_jis
endif
"If it does not include japanese, then use encodinga as fileencoding
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
"}}}
"set encoding=UTF-8 "Set the encoding to UTF-8
"set fileencoding=UTF-8 "Set the encoding to UTF-8
"set termencoding=UTF-8 "Set the encoding to UTF-8

""File
set hidden "Open file even if I'm editing

""Binary Files
augroup BinaryXXD
        autocmd!
        autocmd BufReadPre  *.bin let &binary =1
        autocmd BufReadPre  *.smd let &binary =1
        autocmd BufReadPost * if &binary | silent %!xxd
        autocmd BufReadPost * set ft=xxd | endif
        autocmd BufWritePre * if &binary | %!xxd -r
        autocmd BufWritePre * endif
        autocmd BufWritePost * if &binary | silent %!xxd
        autocmd BufWritePost * set nomod | endif
augroup END

""Create Swapfile
set swapfile
""Do not create backup file (~*** files)
set nobackup

""Search
set incsearch "Incremental search
set hlsearch "Set highlight search word
set wrapscan "If the search ends, goto the beginning
set ignorecase "Disable smart case once
set smartcase "Upper/Lower case letters discreminates

"Indent setting
set shiftwidth=1 "Tab is same as 1 spaces
set tabstop=4 " Tab is same as 4 spaces
set expandtab "Use space instead of inserting Tab
set softtabstop=4 "When inserting tab it is same as 4 spaces

"For source codes
autocmd FileType c,cpp,cs,java,gradle,aidl,xml,html,sh,rs set shiftwidth=4 softtabstop=4 tabstop=4 expandtab cindent "Use C-style indent
autocmd FileType python,py set smartindent shiftwidth=2 softtabstop=2 tabstop=2 expandtab smarttab cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType vim set shiftwidth=2 softtabstop=2 tabstop=2 expandtab cindent

set whichwrap=b,s,h,l,<,>,[,] "goto previous or next line with cursor

""Display
colorscheme desert "Desert theme
set background=dark "Designate background as dark

set number "Show line number
set title "Show title of the file
"set list "Show Tab and other unvisible letters
set showmatch "Show corresponding parenthesis
set matchtime=3 "Highlight the correspondence for 3 seconds

""Syntax settings
syntax on

""Folding setting
""Fold the line between {{{ and }}}
set foldmethod=marker
"For binary files, do not fold
autocmd Filetype xxd,smd setlocal nofoldenable

""Key setting
"End hlsearch with ctrl-e
nnoremap <silent> <C-e> :nohlsearch<CR>
vnoremap <silent> <C-e> <Esc>:nohlsearch<CR>gv
"Paste with Alt-v
map <A-v> "+gP
imap <A-v> <ESC><ESC>"+gPa
"Open file explorer
map <C-x><C-f> :VimFiler<CR>
imap <C-x><C-f> <Esc>:VimFiler<CR>
"Set backspace for deleting
set backspace=start,eol,indent

""Copy to clipboard when yank
nnoremap y "+y
vnoremap y "+y
set clipboard+=unnamedplus

""Comment out region
"lhs comments
vmap ,# :s/^/#/<CR>:nohlsearch<CR>
vmap ,/ :s/^/\/\//<CR>:nohlsearch<CR>
vmap ,> :s/^/> /<CR>:nohlsearch<CR>
vmap ," :s/^/\"/<CR>:nohlsearch<CR>
vmap ,% :s/^/%/<CR>:nohlsearch<CR>
vmap ,! :s/^/!/<CR>:nohlsearch<CR>
vmap ,; :s/^/;/<CR>:nohlsearch<CR>
vmap ,- :s/^/--/<CR>:nohlsearch<CR>
vmap ,c :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

"wrapping comments
vmap ,* :s/^\(.*\)$/\/\* \1 \*\//<CR>:nohlsearch<CR>
vmap ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR>:nohlsearch<CR>
vmap ,< :s/^\(.*\)$/<!-- \1 -->/<CR>:nohlsearch<CR>
vmap ,d :s/^\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$/\2/<CR>:nohlsearch<CR>

"block comments
vmap ,b v`<I<CR><esc>k0i/*<ESC>`>j0i*/<CR><esc><ESC>
vmap ,h v`<I<CR><esc>k0i<!--<ESC>`>j0i--><CR><esc><ESC>

"Indent setting
"set smartindent "Automatically indent
"set autoindent  "Automatically indent
set cindent "Use C-style indent

"Indent continuosly in visual mode
vnoremap > >gv
vnoremap < <gv

"Vim Grep keys
nnoremap [q :cnext<CR>
nnoremap ]q :cprevious<CR>

"Change Font-Size
if has("gui_running")
  if has("gui_gtk2")
    set guifont=MonoSpace\ 12
  elseif has("mac")
    set guifont=Ricty:h16
  elseif has("gui_win32")
    set guifont=MS_Gothic:h12:cSHIFTJIS
  endif
endif

"apply entire code formatting with ctrl-i
function! REFORMAT_ENTIRE_CODE()
  let a:line_num = line(".")
  :exec "normal! ggvG="
  :cal cursor(a:line_num, 0)
endfunction
nnoremap <C-i> :call REFORMAT_ENTIRE_CODE()<CR>

""Delete unnecessary spaces(at the end of line) at saving the file
autocmd BufWritePre * :%s/\s\+$//e

"------------------------------------
"Vimdiff setting
"------------------------------------
""Split vertically in diffsplit
set diffopt=vertical
nmap <silent> do do :diffupdate<CR>
nmap <silent> dp dp :diffupdate<CR>

"------------------------------------
"Automatically change directory
"------------------------------------
au  BufEnter *  execute ":lcd " . expand("%:p:h")

"------------------------------------
"Auto quickgrep
"------------------------------------
autocmd QuickFixCmdPost *grep* cwindow

"------------------------------------
"Toggle Setting
"------------------------------------
:let g:toggle_pairs = { '&&':'||', '||':'&&',
                      \ 'January':'February', 'February':'March', 'March':'April', 'April':'May',
                      \ 'May':'June', 'June':'July', 'July':'August', 'August':'September',
                      \ 'September':'October', 'October':'November', 'November':'December', 'December':'January'}
:imap <silent> <C-c> <Plug>ToggleI
:nmap <silent> <C-c> <Plug>ToggleN

"------------------------------------
" Quick run setting
"------------------------------------
let g:quickrun_config = {
\   'markdown': {
\     'type': 'markdown/gfm',
\     'outputter': 'browser'
\   }
\ }

"------------------------------------
"Gtags Setting
"------------------------------------
"let g:Gtags_Auto_Update = 1
""Goto next result
"nmap <C-n> :cn<CR>
""Goto previous result
"nmap <C-p> :cp<CR>
""Jump to the function/variable
"nmap <C-j> :GtagsCursor<CR>
""List all the function in file
"nmap <C-i> :Gtags -f %<CR>
""Find
"nmap <C-s> :Gtags -x
""Close quickfix window
"nmap <C-q> :ccl<CR>

"------------------------------------
"Buffer Setting
"------------------------------------
map <silent> <F2> :bp<CR>
map <silent> <F3> :bn<CR>

"------------------------------------
"Reload Setting
"------------------------------------
set autoread "If the file changes, read automatically
map <silent> <F5> :e!<CR>

"------------------------------------
"Tab Setting
"------------------------------------
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

" The prefix key.
nnoremap [Tag] <Nop>
nmap t [Tag]
" Tab jump. t1 to first t2 to second ...
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

"tc: Create new tab
map <silent> [Tag]c :tablast <bar> tabnew<CR>
"tx: Close tab
map <silent> [Tag]x :tabclose<CR>
"tn: Next tab
map <silent> [Tag]n :tabnext<CR>
"tp: Previous tab
map <silent> [Tag]p :tabprevious<CR>

" Auto complete parenthesis
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

"------------------------------------
"Show unvisible spaces
"------------------------------------
"Setting to display unvisible spaces"{{{
"Show ZenkakuSpace
highlight ZenkakuSpace cterm=underline ctermbg=darkgray guibg=darkgray
autocmd BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
autocmd WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')"}}}

"------------------------------------
"For CodeForce
"------------------------------------
map <F6> :w<CR>:!g++ % -g && (ulimit -c unlimited; ./a.out < in.txt) <CR>

"------------------------------------
"End Preferences
"------------------------------------

" ------------------- clang_complete -------------
let g:clang_complete_auto=1
let g:clang_auto_select=0
let g:clang_use_library=1
let g:clang_debug=1
let os=substitute(system('uname'), '\n', '', '')
if os == 'Darwin' || os == 'Mac'
let g:clang_library_path="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib"
elseif os == 'linux'
let g:clang_library_path="/usr/lib/llvm-3.4/lib"
endif
let g:clang_user_options = '-std=c++11'

"------------------------------------
" syntastic settings
"------------------------------------
let g:syntastic_rust_checkers = ['rustc']

"------------------------------------
" vim-indent-guides setting
"------------------------------------
"let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_start_level=1
"let g:indent_guides_color_change_percent=50
"let g:indent_guides_guide_size=4
"let g:indent_guides_space_guides=1
"let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * : highlight IndentGuidesOdd guibg=#454545  ctermbg=236
"autocmd VimEnter,Colorscheme * : highlight IndentGuidesEven guibg=#373737 ctermbg=black

"------------------------------------
" neocmplcache
"------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 0
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
"imap <C-k>     <Plug>(neocomplcache_snippets_expand)
"smap <C-k>     <Plug>(neocomplcache_snippets_expand)
"inoremap <expr><C-g>     neocomplcache#undo_completion()
"inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char
"inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

" My Custom key-mappings
inoremap <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
inoremap <expr><C-[>  pumvisible() ? neocomplcache#cancel_popup() : "\<ESC>"
inoremap <expr><C-z> pumvisible() ? neocomplcache#cancel_popup() : "\<ESC>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"do not start popup automatically
let g:neocomplcache_auto_completion_start_length = 1000
"do not popup while moving cursor
inoremap <expr><Up> pumvisible() ? neocomplcache#close_popup()."\<Up>" : "\<Up>"
inoremap <expr><Down> pumvisible() ? neocomplcache#close_popup()."\<Down>" : "\<Down>"

" Enable pop up menu color setting
set completeopt=menuone
highlight Pmenu guibg=#003000 "popup color
highlight PmenuSel guibg=#006800 "popup color
highlight PmenuSbar guibg=#001800 "popup color
highlight PmenuThumb guifg=#006000 "popup color
