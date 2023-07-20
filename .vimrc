set nocompatible
filetype off
" .vimrc for rockfish


" vundle package manager: https://github.com/VundleVim/Vundle.vim
" set up by:  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" run :PluginInstall to install packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Basics
Plugin 'tpope/vim-fugitive'         " git integration
Plugin 'StephenHwang/vim-surround'  " fork of tpope's vim-surround
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
set autoread                " update file on disk change
set mouse=n                 " mouse in normal mode
set backspace=indent,eol,start
let g:indentLine_char = '▏' "indentation guide

"" Search and highlight settings
set shortmess-=S
set ignorecase           " ignore uppercase
set smartcase            " if uppercase in search, consider only uppercase
set incsearch            " move cursor to the matched string while searching
set hlsearch             " highlight search

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
xnoremap P Pgvy

" start of line on gg and G
nnoremap gg gg0
nnoremap G G0
vnoremap gg gg0
vnoremap G G0

" increment numbers
nnoremap <C-q> <C-a>
vnoremap <C-q> g<C-a>

" assorted other shorcuts
map Q gq
nnoremap <leader>ss :s/,/\ /ge<cr> <bar> :s/\s\+/\r/g<cr>:nol<cr>
nnoremap <silent>gs xph

inoremap <BS> X
nnoremap <BS> X

nnoremap X cc<Esc>
nnoremap U <C-R>
command! CD cd %:p:h
command! TW :call TrimWhitespace()

"" Jump to first non-blank, non-bullet character
function! JumpStart()
  if getline('.') =~ '^\s*$'          " if empty line, next line
    :norm j
    return
  endif
  if getline('.') =~ '^\s*\d\+. '     " jump to number bullet start
    :norm 0
    :call search('[A-Za-z]', '', line('.'))
    return
  endif
  if getline('.') =~ '^\s*- '         "  jump to bullet start
    :norm 0
    :call search('[A-Za-z]', '', line('.'))
  else
    :norm ^
  end
endfunction
nnoremap <silent>_ :call JumpStart()<cr>
vnoremap <silent>_ :call JumpStart()<cr>v`<
onoremap <silent>_ :call JumpStart()<cr>

"" Match jump: toggle between matchpairs or front/end of line
function! GetMatchPairs()
  let match_cases = '[' . substitute(substitute(escape(&mps, '[$^.*~\\/?]'), ",", "", "g"), ":", "", "g") . ']'
  return match_cases
endfunction

" Match jump
function! MatchJump()
  if getline('.') =~ '^\s*$'
    :norm j
    return
  endif
  if match(getline('.'), GetMatchPairs()) >= 0
    :norm! %
    return
  else
    if col(".") == col("$")-1
      :call JumpStart()
    else
      :norm $
    endif
 end
endfunction

" Visual match jump
function! VisualMatchJump(cursor_pos)
  :norm `<v
  if a:cursor_pos == col("$")-1
    :call JumpStart()
  else
    :norm $
  endif
endfunction

nnoremap <silent>% :call MatchJump()<cr>
vnoremap <silent><expr> % (match(getline('.'), GetMatchPairs()) >= 0) ? "%" : "v:call VisualMatchJump(col('.'))<cr>"


" marks
"  gb    : select between m and n marks
"  mw    : cursorhold mark
" autocmd CursorHold * echo 'mark l' line(".") | :norm mw
autocmd CursorHold * :norm mw
noremap <silent>`` `m
noremap <silent>gb `nv`m

" copy pasting with system
set clipboard=unnamed "selection and normal clipboard, must have clipboard+ setting
noremap x "_x<silent>
nnoremap Y y$
nnoremap yy "+yy
vnoremap y "+y
vnoremap <C-c> "+y

" marks
"  gb    : select between m and n marks
"  mw    : cursorhold mark
" autocmd CursorHold * echo 'mark l' line(".") | :norm mw
autocmd CursorHold * :norm mw
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

"" Code folding
set foldlevel=99
set foldopen-=block
set foldopen-=search
augroup folding
  au BufReadPre * setlocal foldmethod=indent
  au BufReadPre *.wiki setlocal foldmethod=expr
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" Repeat fold with dot command
function! ToggleFold()
  norm za
endfunction
map <silent><Plug>ToggleFoldMap :call ToggleFold()<cr>:call repeat#set("\<Plug>ToggleFoldMap", v:count)<cr>
nmap <leader>z <Plug>ToggleFoldMap
vnoremap <silent> <leader>z zf

"" FZF delete buffers
function! s:list_buffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! s:delete_buffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

command! BD call fzf#run(fzf#wrap({
command! BufferDelete call fzf#run(fzf#wrap({
  \ 'source': s:list_buffers(),
  \ 'sink*': { lines -> s:delete_buffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
\ }))


"" Quickfix
"    - toggle quickfix with leader c
"    - <C-n/m> cycle quick fix
"    - <right/left> to move between qf
"    - search (:CF[F] <word>) or word under cursor (<leader>n)
"    - :Reject/:Keep to filter elements
nmap <leader>c <Plug>(qf_qf_toggle)
nmap <C-m> <Plug>(qf_qf_previous)
nmap <C-n> <Plug>(qf_qf_next)
autocmd FileType qf nmap <buffer> <Left>  <Plug>(qf_older)
autocmd FileType qf nmap <buffer> <Right>  <Plug>(qf_newer)
autocmd FileType qf nnoremap <silent> <buffer> dd :.Reject<cr>
autocmd FileType qf vnoremap <silent> <buffer> d :'<,'>Reject<cr>
nnoremap <silent> <leader>n :execute 'vimgrep ' . '/\<' . expand("<cword>") . '\>/ ' . join(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '"#".v:val'), ' ')<cr><bar>``
command! -nargs=? CF call AddQuickFixExact(<f-args>)
command! -nargs=? CFF call AddQuickFixPartialMatch(<f-args>)

" Search/add to quickfix
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
autocmd FileType python,r,sh autocmd BufWritePre <buffer> :call TrimWhitespace()
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

"" Nextflow settings
au BufNewFile,BufRead *.nf
      \ set filetype=nextflow |
      \ set syntax=groovy

" vim-fugitive settings
nnoremap gl :0Gclog<cr>

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
function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction
nnoremap <leader>sl :<C-u>call BreakHere()<CR>
nnoremap K :<C-u>call BreakHere()<CR>

" split space
function! SplitSpace()
    s/,/\ /ge
    s/\s\+/\r/g
endfunction
command! SS :call SplitSpace()
command! ReplaceCommas s/,/\ /ge

"" fzf, fuzzy find
let g:fzf_layout = { 'down': '40%' }
nnoremap <C-f>f :Files<cr>
nnoremap <C-f>b :Buffer<cr>
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>t :Buffer<cr>
nnoremap <C-f>a :Rg
nnoremap <C-f>i :BLines<cr>
nnoremap <C-f>h :History<cr>
nnoremap <C-f>g :BCommits<cr>
nnoremap <C-f>G :GFiles?<cr>

"" autocomplete
set completeopt=menuone,longest
set shortmess+=c
au FileType * execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'

"" Toggle comment
let s:comment_map = {
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "nextflow": '\/\/',
    \   "wdl": '#',
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

let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'
hi! link netrwMarkFile Search
nmap <leader>` :Lexplore<CR>

" aethetics
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_y = 0
let g:airline_section_z = airline#section#create(['%5l/%L:%3v'])
let g:airline_section_error = 0
let g:airline_section_warning = 0

" colorscheme
" let g:gruvbox_contrast_dark='hard'
" colorscheme gruvbox
set background=dark
colorscheme gruvbox8
