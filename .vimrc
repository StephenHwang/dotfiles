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


" ale linter:
"   pip install flake8 --user
"   edit flake8 config at: ~/.config/flake8
let g:ale_enabled = 1                       " 0 to disable by default
"nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8']}  " pylint too pedantic
" let g:ale_fixers = {'python': ['trim_whitespace']}
let g:ale_hover_cursor = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '.'
nmap <silent> <leader>L <Plug>(ale_previous_wrap):call repeat#set("\<Plug>(ale_previous_wrap)", v:count)<CR>
nmap <silent> <leader>l <Plug>(ale_next_wrap):call repeat#set("\<Plug>(ale_next_wrap)", v:count)<CR>

" Trim whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" Trim whitespace on Python files


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
nnoremap <leader>wq :wq<cr>
nnoremap <leader>r :source ~/.vimrc<CR> 
nnoremap U <C-R>

" repeat command in visual mode and with count
vnoremap <silent>. :norm.<CR>
nnoremap <silent>. :<C-u>execute "norm! " . repeat(".", v:count1)<CR>

" dot command ciw with gc force change
nnoremap ciw *``cgn
nnoremap gc *``cgn<C-r>.<ESC>

" assorted other shorcuts
nnoremap <leader>sl :s/,/\ /ge<cr> <bar> :s/\s\+/\r/g<cr>:nol<cr>
nnoremap <silent> gs xph
nnoremap <leader>n [I

" copy pasting with system
set clipboard=unnamed "selection and normal clipboard, must have clipboard+ setting
noremap x "_x<silent>
nnoremap <BS> X
nnoremap Y y$
nnoremap yy "+yy
vnoremap y "+y
vnoremap <C-c> "+y

" marks
"   mm and mn to set marks
"   gm and gM to go to marks
"   gb to go between
noremap <silent> mn mNmn
noremap <silent> gm `m
noremap <silent> gM `N
noremap <silent> gb `nv`m

" code folding
set foldmethod=indent
set foldlevel=99
set foldopen-=block
nnoremap <leader>z za 

"" Python specific mappings
au BufNewFile,BufRead *.py
    \ set tabstop=4 "width of tab is set to 4
    \ set softtabstop=4 "sets the number of columns for a tab
    \ set shiftwidth=4 "indents will have width of 4
    \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
autocmd FileType python inoremap <buffer> { {}<Left>
autocmd FileType python inoremap <buffer> [ []<Left>
autocmd FileType python inoremap <buffer> ' ''<Left>
autocmd FileType python ab <buffer> dbg import ipdb; ipdb.set_trace()
autocmd FileType python ab <buffer> ipy import IPython; IPython.embed()
autocmd FileType python ab <buffer> pri print

" youCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_auto_hover = ''
autocmd FileType python nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd FileType python nnoremap <leader>t :YcmCompleter GetType<CR>
autocmd FileType python nmap <leader>d <plug>(YCMHover)

" ale linter:
"   pip install flake8 --user
"   edit flake8 config at: ~/.config/flake8
let g:ale_enabled = 1                       " 0 to disable by default
"nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8']}  " pylint too pedantic
" let g:ale_fixers = {'python': ['trim_whitespace']}
let g:ale_hover_cursor = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '.'
nmap <silent> <leader>L <Plug>(ale_previous_wrap):call repeat#set("\<Plug>(ale_previous_wrap)", v:count)<CR>
nmap <silent> <leader>l <Plug>(ale_next_wrap):call repeat#set("\<Plug>(ale_next_wrap)", v:count)<CR>

" Trim whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
" Trim whitespace on Python files
autocmd FileType python autocmd BufWritePre <buffer> :call TrimWhitespace()

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
"    download tagbar and add file to bin/ctags (chmod +x)
"       https://raw.githubusercontent.com/vimwiki/utils/master/vwtags.py
nnoremap <leader>m :TagbarOpenAutoClose<CR>
let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin': '/home/stephen/bin/ctags-5.8/vwtags.py'
			\ , 'ctagsargs': 'default'
			\ }

" vim-slime: tmux REPL integration
"   :SlimeConfig to configure panels
let g:slime_target = 'tmux'
let g:slime_paste_file = '$HOME/.slime_paste'
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': ':.1'}
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
xmap <c-c><c-c> <Plug>SlimeRegionSend
nmap <c-c><c-c> <Plug>SlimeParagraphSend

"" Search and highlight settings
set ignorecase           " ignore uppercase
set smartcase            " if uppercase in search, consider only uppercase
set incsearch            " move cursor to the matched string while searching
set hlsearch             " highlight search
set wildcharm=<c-z>      " tab to scroll search matches
cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"
nnoremap <leader>h :set hlsearch! hlsearch?<CR>

"" buffers
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>e :bdel<cr>
nnoremap <leader>sd :cd %:p:h<CR>

"" fuzzy find assorted items
nnoremap <C-f> :Files<CR>
nnoremap <C-f>f :Files<CR>
nnoremap <C-f>b :Buffer<cr>
nnoremap <C-f>a :Rg 
nnoremap <C-f>i :BLines<CR>
nnoremap <C-f>h :History<CR>
nnoremap <C-f>g :BCommits<CR>
nnoremap <C-f>G :GFiles?<CR>

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
