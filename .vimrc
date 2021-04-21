set nocompatible 
filetype off

" vundle package manager: https://github.com/VundleVim/Vundle.vim
" set up by:  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" run :PluginInstall to install packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Basics
Plugin 'tpope/vim-fugitive'     " git integration
Plugin 'tpope/vim-surround'     " text surround
Plugin 'tpope/vim-repeat'       " dot command for vim surround
Plugin 'Yggdroot/indentLine'    " display vertical indentation level

" Programming
Plugin 'sheerun/vim-polyglot'   " syntax recognition
Plugin 'Valloric/YouCompleteMe' " autocomplete
Plugin 'dense-analysis/ale'     " linter

" Optional
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vimwiki/vimwiki', {'branch': 'dev'}
Plugin 'jpalardy/vim-slime.git' 

" Aesthetics
Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'          " airline status bar
Plugin 'edkolev/tmuxline.vim'             " tmux status bar

call vundle#end()
filetype plugin indent on 
syntax on

" Save cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Basic vim options
set encoding=utf-8
set lazyredraw
set noshowmode
set noerrorbells
set hidden                  " switch buffers without having to save
set laststatus=2            " powerline status line positioning
set scrolloff=10            " visual scroll gap below the cursor
set cursorline
set number 
set colorcolumn=80          " set line at 80 char
set tabstop=2               " width of tab is set to 2
set softtabstop=2           " number of columns for a tab
set shiftwidth=2            " indents width of 2
set expandtab               " expands tabs into spaces
set helpheight=35
set autoindent
set smartindent
set matchpairs+=<:>
set mouse=n                 " mouse in normal mode
let g:indentLine_char = '▏' "indentation guide

" must mkdir the directories 
set undofile                " persistent undo
set undodir=~/.vim/undodir/
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/

" key maps with leader key
let mapleader="\<space>"
inoremap jk <Esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>r :source ~/.vimrc<cr> 

" repeat command in visual mode and with count
vnoremap <silent>. :norm.<cr>
nnoremap <silent>. :<C-u>execute "norm! " . repeat(".", v:count1)<cr>

" ciw '.' repeat with gc force change word under cursor
nnoremap ciw *``cgn
nnoremap gc *``cgn<C-r>.<ESC>


" Jump to first non-blank, non-bullet character
function! JumpStart()
  if getline('.') =~ '^\s*$'        " Skip empty line
    :call search('[A-Za-z]', '')
    return
  endif
  if getline('.') =~ '^\s*\d\+. '     " toggle numerical list checkbox
    :norm 0
    :call search('[A-Za-z]', '', line('.'))
    return
  endif
  if getline('.') =~ '^\s*- '       " toggle normal list item checkbox
    :norm 0
    :call search('[A-Za-z]', '', line('.'))
  else
    :norm ^
  end
endfunction

nnoremap _ :call JumpStart()<cr>

" assorted other shorcuts
map Q gq
nnoremap <leader>ss :s/,/\ /ge<cr> <bar> :s/\s\+/\r/g<cr>:nol<cr>
nnoremap <silent>gs xph
nnoremap <leader>n [I
nnoremap <BS> X
nnoremap U <C-R>

" commands
command! CD cd %:p:h

" copy pasting with system
set clipboard=unnamed "selection and normal clipboard, must have clipboard+ setting
noremap x "_x<silent>
nnoremap Y "+y$
nnoremap yy "+yy
vnoremap y "+y

" marks: gb to go between m and n marks
" noremap <silent>mm mMmm
noremap <silent>mM mMmm
noremap <silent>`` `m
noremap <silent>gb `nv`m

" code folding
set foldlevel=99
set foldopen-=block
augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" function for repeat fold with dot command
function! ToggleFold()
  norm za
endfunction
map <silent><Plug>ToggleFoldMap :call ToggleFold()<cr>:call repeat#set("\<Plug>ToggleFoldMap", v:count)<cr>
nmap <leader>z <Plug>ToggleFoldMap
vnoremap <leader>z zf

"" Python and R specific mappings
autocmd FileType python,r autocmd BufWritePre <buffer> :call TrimWhitespace() " Trim whitespace on R files
autocmd FileType python,r inoremap <buffer> { {}<Left>
autocmd FileType python,r inoremap <buffer> [ []<Left>
autocmd FileType python,r inoremap <buffer> ' ''<Left>

"" R specific
autocmd FileType r iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

"" Python specific mappings
au BufNewFile,BufRead *.py
    \ set relativenumber |
    \ set tabstop=4 | "width of tab is set to 4
    \ set softtabstop=4 | "sets the number of columns for a tab
    \ set shiftwidth=4 | "indents will have width of 4
    \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
autocmd FileType python iabbr <buffer><silent> ipy import IPython; IPython.embed()<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer><silent> dbg import ipdb; ipdb.set_trace()<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer> pri print
autocmd FileType python command! PY execute '!python %'

" youCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_auto_hover = ''
autocmd FileType python nnoremap gd :YcmCompleter GoToDefinitionElseDeclaration<cr>
autocmd FileType python nnoremap <leader>t :YcmCompleter GetType<cr>
autocmd FileType python nmap <leader>d <plug>(YCMHover)

" ale linter: (:ALEToggle)
"   pip install flake8 --user
"   edit flake8 config at: ~/.config/flake8
let g:ale_enabled = 1                       " 0 to disable by default
let g:ale_linters = {'python': ['flake8'], 'r': ['lintr']}
let g:ale_hover_cursor = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '.'
nmap <silent> <leader>l <Plug>(ale_next_wrap):call repeat#set("\<Plug>(ale_next_wrap)", v:count)<cr>
nmap <silent> <leader>L <Plug>(ale_previous_wrap):call repeat#set("\<Plug>(ale_previous_wrap)", v:count)<cr>

" Trim whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" Remove character after abbr
func Eatchar(pat)
      let c = nr2char(getchar(0))
      return (c =~ a:pat) ? '' : c
endfunc

" timestamp
iabbr ctime <C-R>=DateStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k
iabbr ctimee <C-R>=TimeStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k
if !exists("*TimeStamp")
    fun TimeStamp()
        return strftime("%a %d %b %Y, %X")
    endfun
endif
if !exists("*DateStamp")
    fun DateStamp()
        return strftime("%a %d %b %Y")
    endfun
endif

" split line
nnoremap <leader>sl :<C-u>call BreakHere()<CR>
function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction

"" vimwiki settings
"     see vimwiki ftplugin for more
let g:vimwiki_folding = 'custom'
let g:vimwiki_list = [{ 'path': '~/Documents/notes/' }]
let g:vimwiki_listsyms = ' oX'
let g:vimwiki_key_mappings =
  \ {
  \   'all_maps': 1,
  \   'global': 0,
  \   'headers': 1,
  \   'text_objs': 1,
  \   'table_format': 1,
  \   'table_mappings': 1,
  \   'lists': 1,
  \   'links': 0,
  \   'html': 0,
  \   'mouse': 0,
  \ }

" vimwiki ctags:
"    sudo apt install exuberant-ctags
"    python:
"      download tagbar and add file to bin/ctags (chmod +x)
"       https://raw.githubusercontent.com/vimwiki/utils/master/vwtags.py
"    r:
"      https://tinyheero.github.io/2017/05/13/r-vim-ctags.html
nnoremap <leader>m :TagbarOpenAutoClose<cr>
let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin': '/home/stephen/bin/ctags-5.8/vwtags.py'
			\ , 'ctagsargs': 'default'
			\ }
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

" vim-slime: tmux REPL integration
"   :SlimeConfig to configure panels
let g:slime_target = 'tmux'
let g:slime_paste_file = '$HOME/.slime_paste'
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': ':.1'}
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
autocmd FileType python,r nnoremap <c-c> vip
autocmd FileType python,r xmap <c-c> <Plug>SlimeRegionSend

"" Search and highlight settings
set ignorecase           " ignore uppercase
set smartcase            " if uppercase in search, consider only uppercase
set incsearch            " move cursor to the matched string while searching
set hlsearch             " highlight search
nnoremap <leader>h :set hlsearch! hlsearch?<cr>

"" buffers
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>e :bdel<cr>

" setting mouse horizontal scroll: 
"    https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
execute "set <M-y>=\ey"
execute "set <M-u>=\eu"
nnoremap <M-u> :bn<cr>
nnoremap <M-y> :bp<cr>

"" fuzzy find assorted items
nnoremap <C-f> :Files<cr>
nnoremap <C-f>f :Files<cr>
nnoremap <C-f>b :Buffer<cr>
nnoremap <C-f>a :Rg 
nnoremap <C-f>i :BLines<cr>
nnoremap <C-f>h :History<cr>
nnoremap <C-f>g :BCommits<cr>
nnoremap <C-f>G :GFiles?<cr>

"" Toggle comment
let s:comment_map = { 
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "python": '#',
    \   "r": '#',
    \   "sh": '#',
    \   "bashrc": '#',
    \   "vim": '"',
    \ }

function! ToggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ "^\\s*" . comment_leader . " " 
            " Uncomment the line
            execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
        else 
            if getline('.') =~ "^\\s*" . comment_leader
                " Uncomment the line
                execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
            else
                " Comment the line
                execute "silent s/^\\(\\s*\\)/\\1" . comment_leader . " /"
            end
        end
    else
        echo "No comment for filetype"
    end
endfunction

map <silent><Plug>ToggleCommentMap :call ToggleComment()<cr>:call repeat#set("\<Plug>ToggleCommentMap", v:count)<cr>
nmap <leader>f <Plug>ToggleCommentMap
vmap <leader>f <Plug>ToggleCommentMap

"" aethetics
let g:gruvbox_contrast_dark='medium'
colorscheme gruvbox
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
