set nocompatible 
filetype off

" vundle package manager: https://github.com/VundleVim/Vundle.vim
" set up by:  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" run :PluginInstall to install packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Basics
Plugin 'tpope/vim-fugitive'         " git integration
Plugin 'tpope/vim-surround'         " text surround
Plugin 'tpope/vim-repeat'           " dot command for vim surround
Plugin 'Yggdroot/indentLine'        " display vertical indentation level
Plugin 'romainl/vim-qf'             " quickfix assist

" Programming
Plugin  'vim-scripts/AutoComplPop'  " autocomplete always open
Plugin 'sheerun/vim-polyglot' " syntax 

" Optional
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" Aesthetics
Plugin 'morhetz/gruvbox'
Plugin 'lifepillar/vim-gruvbox8'
Plugin 'vim-airline/vim-airline'          " airline status bar
Plugin 'edkolev/tmuxline.vim'             " tmux status bar

call vundle#end()
filetype plugin indent on 
syntax on

" Save cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " Update a buffer's contents on focus if it changed outside of Vim.
  au FocusGained,BufEnter * :checktime
endif

" Basic vim options
set encoding=utf-8
set lazyredraw
set noshowmode
set showcmd
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
set nostartofline
set matchpairs+=<:>
set autoread                " update file on disk change
set mouse=n                 " mouse in normal mode
let g:indentLine_char = '▏' "indentation guide

"" Search and highlight settings
set ignorecase           " ignore uppercase
set smartcase            " if uppercase in search, consider only uppercase
set incsearch            " move cursor to the matched string while searching
set hlsearch             " highlight search

" key maps with leader key
let mapleader="\<space>"
inoremap jk <Esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>r :source ~/.vimrc<cr>
nnoremap <space> <nop>

" navigate windows with C-hjkl
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-l> :wincmd w<CR>
nnoremap <silent> <leader>o :wincmd w<CR>

" repeat command in visual mode and with count
vnoremap <silent>. :norm.<cr>
nnoremap <silent>. :<C-u>execute "norm! " . repeat(".", v:count1)<cr>

" ciw '.' repeat with gc force change word under cursor
nnoremap ciw *``cgn
nnoremap gc *``cgn<C-r>.<ESC>

" prevent paste from overwriting original copy
xnoremap p pgvy

" start of line on gg and G
nnoremap gg gg0
nnoremap G G0
vnoremap gg gg0
vnoremap G G0

" assorted other shorcuts
map Q gq
nnoremap <leader>ss :s/,/\ /ge<cr> <bar> :s/\s\+/\r/g<cr>:nol<cr>
nnoremap <silent>gs xph
nnoremap <BS> X
inoremap <BS> X
nnoremap X cc<Esc>
nnoremap U <C-R>
command! CD cd %:p:h

" Vim surround: s instead of ys or S
nmap s <Plug>Ysurround
xmap s <Plug>VSurround

" must mkdir the directories 
set undofile " persistent undo
set undodir=~/.vim/undodir/
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/

" copy pasting with system
set clipboard=unnamed "selection and normal clipboard, must have clipboard+ setting
noremap x "_x<silent>
nnoremap <BS> X
nnoremap Y y$
nnoremap yy "+yy
vnoremap y "+y
vnoremap <C-c> "+y

" remaps
" move visual selection up and down a line
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" marks: gb to go between m and n marks
noremap <silent>`` `m
noremap <silent>gb `nv`m

" navigate buffers
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>l <C-^>
nnoremap <leader>e :bdel<cr>
execute "set <M-y>=\ey"
execute "set <M-u>=\eu"
nnoremap <M-u> :bn<cr>
nnoremap <M-y> :bp<cr>

" code folding
set foldlevel=99
set foldopen-=block
augroup folding
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" function for repeat fold with dot command
function! ToggleFold()
  norm za
endfunction
map <silent><Plug>ToggleFoldMap :call ToggleFold()<cr>:call repeat#set("\<Plug>ToggleFoldMap", v:count)<cr><Down>
nmap <leader>z <Plug>ToggleFoldMap
vnoremap <silent> <leader>z zf

"" Quickfix
"    - toggle quickfix with leader c
"    - <C-m/n> cycle quick fix
"    - move between qf using :colder :cnewer
"    - search (:CF <word>) or word under cursor (<leader>n)
"    - Reject/Keep to filter elements
nnoremap <silent> <leader>c :copen<cr>
autocmd FileType qf nnoremap <silent> <buffer> <leader>c :ccl<cr>
nmap <C-m> <Plug>(qf_qf_previous)
nmap <C-n> <Plug>(qf_qf_next)
autocmd FileType qf nnoremap <silent> <buffer> dd :.Reject<cr>
autocmd FileType qf vnoremap <silent> <buffer> d :'<,'>Reject<cr>

" Search/add to quickfix
nnoremap <silent> <leader>n :execute 'vimgrep ' . '/\<' . expand("<cword>") . '\>/ ' . join(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '"#".v:val'), ' ')<cr><bar>``
command! -nargs=? CF call AddQuickFixExact(<f-args>)
function! AddQuickFixExact(...)
  let arg1 = get(a:, 0, 0)
  if arg1
    silent! execute 'vimgrepa ' . '/\<' . expand(a:1) . '\>/ ' . join(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '"#".v:val'), ' ')
  else
    if getline('.') =~ '^\s*$'        " Skip empty line
      cw
      return
    endif
    silent! caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")
    wincmd k
  endif
endfunction

" Add partial matches
command! -nargs=? CFF call AddQuickFixPartialMatch(<f-args>)
function! AddQuickFixPartialMatch(...)
  let arg1 = get(a:, 0, 0)
  if arg1
    silent! execute 'vimgrepa ' expand(a:1) join(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '"#".v:val'), ' ')
  else
    if getline('.') =~ '^\s*$'        " Skip empty line
      cw
      return
    endif
    silent! caddexpr expand("%") . ":" . line(".") .  ":" . getline(".")
    wincmd k
  endif
endfunction


"" Python and R  mappings
autocmd FileType python,r,cpp autocmd BufWritePre <buffer> :call TrimWhitespace()
autocmd FileType python,r inoremap <buffer> { {}<Left>
autocmd FileType python,r inoremap <buffer> [ []<Left>
autocmd FileType python,r inoremap <buffer> ' ''<Left>
autocmd FileType r iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>
autocmd FileType c vnoremap <leader>f/ <C-v>0<S-i>//<Esc>
autocmd FileType c inoremap { {}<Left>
autocmd FileType c inoremap [ []<Left>
autocmd FileType c inoremap ' ''<Left>

"" Python mappings
au BufNewFile,BufRead *.py
      \ set tabstop=4 |       " width of tab is set to 4
      \ set softtabstop=4 |   " sets the number of columns for a tab
      \ set shiftwidth=4 |    " indents will have width of 4
      \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
autocmd FileType python iabbr <buffer><silent> ipy import IPython; IPython.embed()  # TODO<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer><silent> pdb import ipdb; ipdb.set_trace()  # TODO<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType r iabbr <buffer><silent> brow browser()  # TODO:<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer> pri print
autocmd FileType python command! PY execute '!python %'

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
if !exists("*DateStamp")
  fun DateStamp()
    return strftime("%a %d %b %Y")
  endfun
endif
if !exists("*TimeStamp")
  fun TimeStamp()
    return strftime("%a %d %b %Y, %X")
  endfun
endif
iabbr dtime <C-R>=DateStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k
iabbr ctime <C-R>=TimeStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k

" split line
nnoremap <leader>sl :<C-u>call BreakHere()<CR>
function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction

"" fuzzy find
nnoremap <C-f>f :Files<cr>
nnoremap <C-f>b :Buffer<cr>
nnoremap <leader>b :Buffer<cr>
nnoremap <C-f>a :Rg
nnoremap <C-f>i :BLines<cr>
nnoremap <C-f>h :History<cr>
nnoremap <C-f>g :BCommits<cr>
nnoremap <C-f>G :GFiles?<cr>

"" autocomplete
au FileType * execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Down>" or "j"
set completeopt=menuone,longest
set shortmess+=c

"" Toggle comment
let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "python": '#',
    \   "r": '#',
    \   "sh": '#',
    \   "bashrc": '#',
    \   "vim": '"',
    \   "scheme": ';;',
    \   "tex": '%',
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

" highlight toggle
nnoremap <leader>h :set hlsearch! hlsearch?<cr>

" Disable netrw.
"let g:loaded_netrw  = 1
"let g:loaded_netrwPlugin = 1
"let g:loaded_netrwSettings = 1
"let g:loaded_netrwFileHandlers = 1


" aethetics
let g:airline#extensions#whitespace#enabled = 0 " no trailing whitespace check
let g:airline#extensions#tabline#enabled = 1 " automatically show all buffers when only one tab open
let g:airline#extensions#tabline#buffer_nr_show = 1 " show buffer number

set background=dark
colorscheme gruvbox8
