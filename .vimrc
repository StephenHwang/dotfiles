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
" see commit for simple autocomplete: 4bbf5449c5340117644e75bb7bf635b1d08c5bfc
Plugin  'vim-scripts/AutoComplPop'  " autocomplete always open
Plugin 'sheerun/vim-polyglot'       " syntax recognition
Plugin 'dense-analysis/ale'         " linter
Plugin 'Valloric/YouCompleteMe'     " autocomplete

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
nnoremap <space> <nop>

" navigate windows with C-hjkl
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

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
nnoremap <BS> X
nnoremap X cc<Esc>
nnoremap U <C-R>
command! CD cd %:p:h
nmap S <Plug>Ysurround

" copy pasting with system
"   selection and normal clipboard
"   must have clipboard+ setting
set clipboard=unnamed
noremap x "_x<silent>
nnoremap Y "+y$
nnoremap yy "+yy
vnoremap y "+y

" marks: gb to go between m and n marks
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
map <silent><Plug>ToggleFoldMap :call ToggleFold()<cr>:call repeat#set("\<Plug>ToggleFoldMap", v:count)<cr><Down>
nmap <leader>z <Plug>ToggleFoldMap
vnoremap <silent> <leader>z zf

"" Quickfix
"    - toggle quickfix with leader c
"    - <C-m/n> cycle quick fix
"    - move between qf using :colder :cnewer
"    - search (:CF <word>) or word under cursor (<leader>n)
"    - dd delete element
"    - cc# go to nth element
"    - Reject/Keep to filter elements
"    - CW/CR <name> to read and write quickfix
nnoremap <silent> <leader>c :copen<cr>
autocmd FileType qf nnoremap <silent> <buffer> <leader>c :ccl<cr>
nmap <C-m> <Plug>(qf_qf_previous)
nmap <C-n> <Plug>(qf_qf_next)
autocmd FileType qf nnoremap <silent> <buffer> dd :.Reject<cr>
autocmd FileType qf vnoremap <silent> <buffer> d :'<,'>Reject<cr>

" Search/add to quickfix
nnoremap <silent> <leader>n :execute 'vimgrep ' . '/\<' . expand("<cword>") . '\>/ ' . join(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), '"#".v:val'), ' ')<cr><bar>``
command! -nargs=? CF call AddQuickFix(<f-args>)
function! AddQuickFix(...)
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

" Save/Load quickfix
function! s:qf_to_filename(qf) abort
  for i in range(len(a:qf.items))
    let d = a:qf.items[i]
    if bufexists(d.bufnr)
      let d.filename = fnamemodify(bufname(d.bufnr), ':p')
    endif
    silent! call remove(d, 'bufnr')
    let a:qf.items[i] = d
  endfor
  return a:qf
endfunction
command! -bar -nargs=1 -complete=file CW call writefile([js_encode(s:qf_to_filename(getqflist({'all': 1})))], $HOME . '/.vim/qfix/'.<f-args>)
command! -bar -nargs=1 -complete=file CR call setqflist([], ' ', js_decode(get(readfile($HOME . '/.vim/qfix/'.<f-args>), 0, '')))<bar>cw<bar>wincmd k

"" Python and R  mappings
autocmd FileType python,r,vimwiki autocmd BufWritePre <buffer> :call TrimWhitespace()
autocmd FileType python,r inoremap <buffer> { {}<Left>
autocmd FileType python,r inoremap <buffer> [ []<Left>
autocmd FileType python,r inoremap <buffer> ' ''<Left>
autocmd FileType r iabbr <silent> if if ()<Left><C-R>=Eatchar('\s')<CR>

"" Python specific mappings
au BufNewFile,BufRead *.py
    \ set tabstop=4 | "width of tab is set to 4
    \ set softtabstop=4 | "sets the number of columns for a tab
    \ set shiftwidth=4 | "indents will have width of 4
    \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
autocmd FileType python iabbr <buffer><silent> ipy import IPython; IPython.embed()  # TODO<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer><silent> pdb import ipdb; ipdb.set_trace()  # TODO<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType r iabbr <buffer><silent> brow browser()  # TODO<c-r>=Eatchar('\m\s\<bar>/')<cr>
autocmd FileType python iabbr <buffer> pri print
autocmd FileType python command! PY execute '!python %'

" youCompleteMe settings
" always open autocomplete with AutoComplPop
"au FileType * execute 'setlocal dict+=~/.vim/words/'.&filetype.'.txt'
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "j"
"set completeopt=menuone,longest
"set shortmess+=c
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'netrw': 1,
      \ 'text': 1,
      \}
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
autocmd FileType python,r nmap <silent> <leader>y <Plug>(ale_next_wrap):call repeat#set("\<Plug>(ale_next_wrap)", v:count)<cr>
autocmd FileType python,r nmap <silent> <leader>Y <Plug>(ale_previous_wrap):call repeat#set("\<Plug>(ale_previous_wrap)", v:count)<cr>

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
iabbr ctime <C-R>=DateStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k
iabbr ctimee <C-R>=TimeStamp()<CR><C-R>=Eatchar('\s')<CR><Esc>k

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
  \   'table_format': 0,
  \   'table_mappings': 0,
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
nnoremap <leader>l <C-^>
nnoremap <leader>e :bdel<cr>

" setting mouse horizontal scroll: 
"    https://vi.stackexchange.com/questions/2350/how-to-map-alt-key
execute "set <M-y>=\ey"
execute "set <M-u>=\eu"
nnoremap <M-u> :bn<cr>
nnoremap <M-y> :bp<cr>

"" fuzzy find assorted items
nnoremap <C-f>f :Files<cr>
nnoremap <C-f>b :Buffer<cr>
nnoremap <leader>b :Buffer<cr>
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

"" aethetics
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_section_y = 0
let g:airline_section_z = airline#section#create(['%5l/%L:%3v'])
let g:airline_section_error = 0
let g:airline_section_warning = 0

" colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
