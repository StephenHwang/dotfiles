set nocompatible 
filetype off

" vundle package manager: https://github.com/VundleVim/Vundle.vim
" set up by:  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" run :PluginInstall to install packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

Plugin 'Yggdroot/indentLine'    " display vertical indentation level
Plugin 'dense-analysis/ale'     " linter
Plugin 'sheerun/vim-polyglot'   " syntax 
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

Plugin 'majutsushi/tagbar'
Plugin 'jszakmeister/markdown2ctags'
Plugin 'vimwiki/vimwiki', {'branch': 'dev'}
Plugin 'jpalardy/vim-slime.git' 

Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline'          " airline status bar
Plugin 'vim-airline/vim-airline-themes'   " airline theme
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
let g:indentLine_char = '▏' "indentation guide

" must mkdir the directories 
set undofile                " persistent undo
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

" key maps with leader key
let mapleader="\<space>"
inoremap jk <Esc>
inoremap jj <C-o>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>r :source ~/.vimrc<CR> 
nnoremap <silent>ciww *``cgn
vnoremap <silent>. :norm.<CR>
nnoremap <silent>. :<C-u>execute "norm! " . repeat(".", v:count1)<CR>
nnoremap <leader>sl :s/,/\ /ge<cr> <bar> :s/\s\+/\r/g<cr>
nnoremap <silent> gs xph
nnoremap <silent> gc ~

" code folding
set foldmethod=indent
set foldlevel=99
set foldopen-=block
nnoremap <leader>z za 

" tagbar
nnoremap <leader>m :TagbarOpenAutoClose<CR>

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
autocmd FileType python vnoremap <buffer> <leader>f <C-v>0<S-i>#<Esc>
autocmd FileType python nnoremap <buffer> <leader>f 0i#<Esc>
autocmd FileType python ab <buffer> dbg import ipdb; ipdb.set_trace()
autocmd FileType python ab <buffer> ipy import IPython; IPython.embed()

" youCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_auto_hover = ''
nmap <leader>d <plug>(YCMHover)
autocmd FileType python nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
autocmd FileType python nnoremap <leader>t :YcmCompleter GetType<CR>

" ale linter:
"   pip install flake8 and pylint --user
nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {
\   'python': ['remove_trailing_lines', 'trim_whitespace', 'isort'],
\}
let g:ale_hover_cursor = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '.'
nmap <silent> <C-n> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)


"" vimwiki settings
"     see vimwiki ftplugin for more
let g:vimwiki_folding = 'custom'
let g:vimwiki_list = [{ 'path': '~/Documents/notes/' }]
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
"    >sudo apt install exuberant-ctags
"    download and add to bin/ctags: https://gist.github.com/EinfachToll/9071573
let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin':'/home/stephen/.vim/bundle/markdown2ctags/vwtags.py'
			\ , 'ctagsargs': 'default'
			\ }

" vim-silme
"   tmux REPL integration
let g:slime_target = 'tmux'
let g:slime_paste_file = '$HOME/.slime_paste'
let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': ':.1'}
let g:slime_dont_ask_default = 1
let g:slime_no_mappings = 1
xmap <c-c><c-c> <Plug>SlimeRegionSend
nmap <c-c><c-c> <Plug>SlimeParagraphSend
nmap <c-c>v     <Plug>SlimeConfig

"" Search and highlight settings
set ignorecase           " ignore uppercase
set smartcase            " if uppercase in search, consider only uppercase
set incsearch            " move cursor to the matched string while searching
set hlsearch             " highlight search
set wildcharm=<c-z>      " tab to scroll search matches
cnoremap <expr> <Tab>   getcmdtype() =~ '[?/]' ? "<c-g>" : "<c-z>"
cnoremap <expr> <S-Tab> getcmdtype() =~ '[?/]' ? "<c-t>" : "<S-Tab>"
nnoremap <leader>h :set hlsearch! hlsearch?<CR>

" FZF and buffers
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>e :bdel<cr>
nnoremap <leader>sd :cd %:p:h<CR>

" fuzzy find assorted items
nnoremap <C-f>a :Rg 
nnoremap <C-f>i :BLines<CR>
nnoremap <C-f>f :Files<CR>
nnoremap <C-f>m :Marks<CR>
nnoremap <C-f>g :GFiles?<CR>
nnoremap <C-f>h :History<CR>
nnoremap <C-f>w [I

"" aethetics
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
let g:airline#extensions#whitespace#enabled = 0     " no trailing whitespace check
let g:airline#extensions#tabline#enabled = 1        " always show buffers status bar
