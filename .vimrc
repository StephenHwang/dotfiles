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

Plugin 'Yggdroot/indentLine' "indentation guides
Plugin 'dense-analysis/ale' " linter
Plugin 'sheerun/vim-polyglot' " syntax 
Bundle 'Valloric/YouCompleteMe'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'majutsushi/tagbar'
Plugin 'jszakmeister/markdown2ctags'

Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'vimwiki/vimwiki', {'branch': 'dev'} " vim-wiki

Plugin 'vim-airline/vim-airline' " airline statusbar
Plugin 'vim-airline/vim-airline-themes' "airline theme
Bundle 'edkolev/tmuxline.vim'
Plugin 'morhetz/gruvbox'
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

" autocomplete of various brackets in Python
autocmd FileType python inoremap { {}<Left>
autocmd FileType python inoremap [ []<Left>
autocmd FileType python inoremap ' ''<Left>
autocmd FileType python vnoremap <leader>f <C-v>0<S-i>#<Esc>
autocmd FileType python nnoremap <leader>f 0i#<Esc>

" python abbreviations
autocmd FileType python ab dbg import ipdb; ipdb.set_trace()
autocmd FileType python ab ipy import IPython; IPython.embed()
autocmd FileType python ab namemain if __name__ == "__main__":<CR> main()

" autocomplete of brackets in C
autocmd FileType c vnoremap <leader>f/ <C-v>0<S-i>//<Esc>
autocmd FileType c inoremap { {}<Left>
autocmd FileType c inoremap [ []<Left>
autocmd FileType c inoremap ' ''<Left>

" vimwiki abbreviations
autocmd FileType vimwiki ab hte the
autocmd FileType vimwiki ab htey they
autocmd FileType vimwiki ab nad and
autocmd FileType vimwiki ab ofr for
autocmd FileType vimwiki ab ot to
autocmd FileType vimwiki ab ont not
autocmd FileType vimwiki ab ohter other
autocmd FileType vimwiki ab tho though
autocmd FileType vimwiki ab thru through
autocmd FileType vimwiki ab w with
autocmd FileType vimwiki ab isnt isn't
autocmd FileType vimwiki ab cant can't
autocmd FileType vimwiki ab dont don't
autocmd FileType vimwiki ab wouldnt wouldn't
autocmd FileType vimwiki ab wo without
autocmd FileType vimwiki ab bc because
autocmd FileType vimwiki ab bw between
autocmd FileType vimwiki ab diff different
autocmd FileType vimwiki ab ppl people
autocmd FileType vimwiki ab rxn reaction
autocmd FileType vimwiki ab def definitely
autocmd FileType vimwiki ab prb probability
autocmd FileType vimwiki ab prob probably
autocmd FileType vimwiki ab pi π
autocmd FileType vimwiki ab theta θ
autocmd FileType vimwiki ab Delta Δ
autocmd FileType vimwiki ab mu μ
autocmd FileType vimwiki ab dg °
autocmd FileType vimwiki ab <> ⇌
autocmd FileType vimwiki inoremap ( ()<Left>
autocmd FileType vimwiki inoremap " ""<Left>
autocmd FileType vimwiki ab url [[link\|desc] ]<esc>10h

" ale linter
" must pip install flake8, pylint, and yapf --user
" fixes syntax on save and l to toggle on/off
nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {
\   'python': ['remove_trailing_lines', 'trim_whitespace'],
\}
"\   'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf'],
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
nnoremap <silent> gc xph
noremap x "_x<silent>
nnoremap <BS> X
nnoremap Y y$
nnoremap yy "+yy
vnoremap y "+y
vnoremap <C-c> "+y

" FZF
nnoremap <leader>s :Files<CR>

" split line
nnoremap <leader>ss :s/\s\+/\r/g<cr>

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
let g:vimwiki_key_mappings =
  \ {
  \   'all_maps': 1,
  \   'global': 1,
  \   'headers': 1,
  \   'text_objs': 1,
  \   'table_format': 1,
  \   'table_mappings': 1,
  \   'lists': 1,
  \   'links': 0,
  \   'html': 0,
  \   'mouse': 0,
  \ }
autocmd FileType vimwiki nnoremap <silent><tab> :VimwikiNextLink<cr>
autocmd FileType vimwiki nnoremap <silent><s-tab> :VimwikiPrevLink<cr>
autocmd FileType vimwiki nnoremap <cr> :VimwikiFollowLink<cr>
autocmd FileType vimwiki nnoremap <leader>table :VimwikiTable<cr>
autocmd FileType vimwiki nnoremap <leader>wi <nop>
autocmd FileType vimwiki nnoremap <leader>w<leader>w <nop>

" tagbar
" ctags with vimwiki
"  sudo apt install exuberant-ctags
"  download https://gist.githubusercontent.com/EinfachToll/9071573/raw/0b5a629a489c4fe14ba57606d761bd8018746d6c/vwtags.py 
"  add to ctatgsbin path
nnoremap <leader>m :TagbarOpenAutoClose<CR>
let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin':'/home/stephen/.vim/bundle/markdown2ctags/vwtags.py'
			\ , 'ctagsargs': 'default'
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
