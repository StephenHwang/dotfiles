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

Plugin 'Yggdroot/indentLine'
Plugin 'dense-analysis/ale'     " linter
Plugin 'sheerun/vim-polyglot'   " syntax 
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'majutsushi/tagbar'
Plugin 'jszakmeister/markdown2ctags'
Plugin 'vimwiki/vimwiki', {'branch': 'dev'}

Plugin 'morhetz/gruvbox'
Plugin 'vim-airline/vim-airline' " airline statusbar
Plugin 'vim-airline/vim-airline-themes' "airline theme
Plugin 'edkolev/tmuxline.vim'
call vundle#end()
filetype plugin indent on 

" Save cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

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

" key maps with leader key
let mapleader="\<space>"
inoremap jk <Esc>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>wq :wq<cr>
nnoremap ciw *``cgn
vnoremap . :norm.<CR>
nnoremap <Leader>r :source ~/.vimrc<CR> 

" FZF and buffers
set hidden " allows switching of buffers without saving in between
nnoremap <leader>b :Buffer<cr>
nnoremap <leader>k :bn<cr>
nnoremap <leader>j :bp<cr>
nnoremap <leader>e :bdel<cr>
nnoremap <leader>s :Files<CR>

" split line
nnoremap <leader>ss :s/\s\+/\r/g<cr>

"" Python specific mappings
au BufNewFile,BufRead *.py
    \ set tabstop=4 "width of tab is set to 4
    \ set softtabstop=4 "sets the number of columns for a tab
    \ set shiftwidth=4 "indents will have width of 4
    \ set fileformat=unix
let python_highlight_all=1 " python syntax highlight
syntax on

" autocomplete of various brackets in Python
autocmd FileType python inoremap <buffer> { {}<Left>
autocmd FileType python inoremap <buffer> [ []<Left>
autocmd FileType python inoremap <buffer> ' ''<Left>
autocmd FileType python vnoremap <buffer> <leader>f <C-v>0<S-i>#<Esc>
autocmd FileType python nnoremap <buffer> <leader>f 0i#<Esc>

" python abbreviations
autocmd FileType python ab <buffer> dbg import ipdb; ipdb.set_trace()
autocmd FileType python ab <buffer> ipy import IPython; IPython.embed()
autocmd FileType python ab <buffer> namemain if __name__ == "__main__":<CR> main()

"" C specific mappings
autocmd FileType c vnoremap <buffer> <leader>f/ <C-v>0<S-i>//<Esc>
autocmd FileType c inoremap <buffer> { {}<Left>
autocmd FileType c inoremap <buffer> [ []<Left>
autocmd FileType c inoremap <buffer> ' ''<Left>

" ale linter
"   must pip install flake8, pylint, and yapf --user
"   may include 'yapf' to autoformat
nnoremap <leader>l :ALEToggle<CR> 
let g:ale_linters = {'python': ['flake8', 'pylint']}
let g:ale_fixers = {
\   'python': ['remove_trailing_lines', 'trim_whitespace'],
\}
"\   'python': ['remove_trailing_lines', 'trim_whitespace'],
"\   'python': ['remove_trailing_lines', 'trim_whitespace', 'yapf'],
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '•'
let g:ale_sign_warning = '.'
nmap <silent> <C-n> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_next_wrap)

" youCompleteMe settings
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>t :YcmCompleter GetType<CR>

" code folding
nnoremap <leader>z za 
set foldmethod=indent
set foldlevel=99

" tagbar
" for ctags with vimwiki:
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

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR> 
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore .pyc files in NERDTree
let g:NERDTreeQuitOnOpen = 1
autocmd StdinReadPre * let s:std_in=1
let NERDTreeMinimalUI=1

"" vim-wiki
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

" vimwiki mappings
autocmd FileType vimwiki nnoremap <buffer> <silent><tab> :VimwikiNextLink<cr>
autocmd FileType vimwiki nnoremap <buffer> <silent><s-tab> :VimwikiPrevLink<cr>
autocmd FileType vimwiki nnoremap <buffer> <cr> :VimwikiFollowLink<cr>
autocmd FileType vimwiki nnoremap <buffer> <leader>table :VimwikiTable<cr>
autocmd FileType vimwiki nnoremap <buffer> <leader>wi <nop>
autocmd FileType vimwiki nnoremap <buffer> <leader>w<leader>w <nop>
autocmd FileType vimwiki inoremap <buffer> ( ()<Left>
autocmd FileType vimwiki inoremap <buffer> " ""<Left>

" vimwiki abbrieviation
autocmd FileType vimwiki ab <buffer> hte the
autocmd FileType vimwiki ab <buffer> htey they
autocmd FileType vimwiki ab <buffer> nad and
autocmd FileType vimwiki ab <buffer> ofr for
autocmd FileType vimwiki ab <buffer> ot to
autocmd FileType vimwiki ab <buffer> ont not
autocmd FileType vimwiki ab <buffer> ohter other
autocmd FileType vimwiki ab <buffer> tho though
autocmd FileType vimwiki ab <buffer> thru through
autocmd FileType vimwiki ab <buffer> w with
autocmd FileType vimwiki ab <buffer> isnt isn't
autocmd FileType vimwiki ab <buffer> cant can't
autocmd FileType vimwiki ab <buffer> dont don't
autocmd FileType vimwiki ab <buffer> wouldnt wouldn't
autocmd FileType vimwiki ab <buffer> wo without
autocmd FileType vimwiki ab <buffer> bc because
autocmd FileType vimwiki ab <buffer> bw between
autocmd FileType vimwiki ab <buffer> diff different
autocmd FileType vimwiki ab <buffer> ppl people
autocmd FileType vimwiki ab <buffer> rxn reaction
autocmd FileType vimwiki ab <buffer> def definitely
autocmd FileType vimwiki ab <buffer> prb probability
autocmd FileType vimwiki ab <buffer> prob probably
autocmd FileType vimwiki ab <buffer> pi π
autocmd FileType vimwiki ab <buffer> theta θ
autocmd FileType vimwiki ab <buffer> Delta Δ
autocmd FileType vimwiki ab <buffer> mu μ
autocmd FileType vimwiki ab <buffer> dg °
autocmd FileType vimwiki ab <buffer> <> ⇌
autocmd FileType vimwiki ab <buffer> url [[link\|desc] ]<esc>10h

"" aethetics
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox

" airline status line
let g:airline#extensions#whitespace#enabled = 0 " no trailing whitespace check
let g:airline#extensions#tabline#enabled = 1 " automatically show all buffers when only one tab open
let g:airline#extensions#tabline#buffer_nr_show = 1 " show buffer number
