set nocompatible 
filetype off

" vundle package manager: https://github.com/VundleVim/Vundle.vim
" set up by:  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" run :PluginInstall to install packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'majutsushi/tagbar' " space+m usage of tags for overall structure of file
Plugin 'jszakmeister/markdown2ctags'
Plugin 'Yggdroot/indentLine' "indentation guides
Plugin 'vim-airline/vim-airline' " airline statusbar
Plugin 'vim-airline/vim-airline-themes' "airline theme
Plugin 'dense-analysis/ale' " linter
Plugin 'sheerun/vim-polyglot' " syntax 
Bundle 'Valloric/YouCompleteMe'
Bundle 'edkolev/tmuxline.vim'
Plugin 'tpope/vim-surround'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'morhetz/gruvbox'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-fugitive' " git integration
Plugin 'vimwiki/vimwiki', {'branch': 'dev'} " vim-wiki
call vundle#end()
filetype plugin indent on 

" Save cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" key maps with leader key
let mapleader="\<space>"
nnoremap <Leader>r :source ~/.vimrc<CR> 
inoremap jk <Esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>wq :wq<cr>
nnoremap ciw *``cgn
vnoremap . :norm.<CR>

" python specific mappings
au BufNewFile,BufRead *.py
    \ set tabstop=4 "width of tab is set to 4
    \ set softtabstop=4 "sets the number of columns for a tab
    \ set shiftwidth=4 "indents will have width of 4
    \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
syntax on

" autocomplete of various brackets in Python and c
autocmd FileType python inoremap { {}<Left>
autocmd FileType python inoremap [ []<Left>
autocmd FileType python inoremap ' ''<Left>
autocmd FileType python nnoremap <leader>p <S-i>print(<C-o>A)<Esc> 
autocmd FileType python vnoremap <leader>f <C-v>0<S-i># <Esc>
autocmd FileType python nnoremap <leader>f 0i# <Esc>
autocmd FileType c vnoremap <leader>f/ <C-v>0<S-i>//<Esc>
autocmd FileType c inoremap { {}<Left>
autocmd FileType c inoremap [ []<Left>
autocmd FileType c inoremap ' ''<Left>

" ale linter
" must pip install flake8, pylint, and yapf --user
" fixes syntax on save and l to toggle on/off
nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {
\   'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf'],
\}
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '●'
let g:ale_sign_warning = '.'
nmap <silent> <C-n> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)

" Basic vim options
set encoding=utf-8
set lazyredraw
set noshowmode
set noerrorbells
set laststatus=2 " powerline status line positioning
set scrolloff=10 " 3 visual lines below the cursor when scrolling
set cursorline
set number 
set colorcolumn=80 "set line at 80 char
set tabstop=2 "width of tab is set to 2
set softtabstop=2 "sets the number of columns for a tab
set shiftwidth=2 "indents will have width of 2
set expandtab "expandstabs into spaces
set autoindent
set smartindent
set matchpairs+=<:>
let g:indentLine_char = '▏' "indentation guide

" search and highlight settings
set ignorecase " ignore uppercase
set smartcase " if uppercase in search, consider only uppercase
set incsearch " move cursor to the matched string while searching
set hlsearch " highlight search, :noh will temporarily remove highlighting
nnoremap <leader>h :set hlsearch! hlsearch?<CR>

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

" FZF
nnoremap <C-p> :Files<CR>
nnoremap <leader>s :Files<CR>

" buffers
set hidden " allows switching of buffers without saving in between
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>e :bdel<cr>

" airline status line
let g:airline#extensions#whitespace#enabled = 0 " no trailing whitespace check
let g:airline#extensions#tabline#enabled = 1 " automatically show all buffers when only one tab open
let g:airline#extensions#tabline#buffer_nr_show = 1 " show buffer number

"toggle NERDTree
nnoremap <leader>n :NERDTreeToggle<CR> 
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore .pyc files in NERDTree
let g:NERDTreeQuitOnOpen = 1
autocmd StdinReadPre * let s:std_in=1
let NERDTreeMinimalUI=1

" vim-wiki
let g:vimwiki_list = [{ 'path': '~/Documents/notes/' }]

" tagbar: open, focus, and close on new tag
nnoremap <leader>m :TagbarOpenAutoClose<CR>
let g:tagbar_type_markdown = {
    \ 'ctagstype': 'markdown',
    \ 'ctagsbin' : '/home/stephen/.vim/bundle/markdown2ctags/markdown2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
    \ ],
    \ 'sro' : '|',
    \ 'kind2scope' : {
        \ 's' : 'section',
    \ },
    \ 'sort': 0,
\ }

" youCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>t  :YcmCompleter GetType<CR>

" code folding
nnoremap <leader>z za 
set foldmethod=indent
set foldlevel=99

let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox
