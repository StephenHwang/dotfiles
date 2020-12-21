" vimwiki folding adopted from
" https://vimwiki.github.io/vimwikiwiki/Tips%20and%20Snips.html
setlocal foldlevel=99
setlocal foldenable
setlocal foldmethod=expr
setlocal foldexpr=Fold(v:lnum)

 function! Fold(lnum)
   let fold_level = strlen(matchstr(getline(a:lnum), '^' . '=' . '\+'))
   if (fold_level)
     return '>' . fold_level  " start a fold level
   endif
   if getline(a:lnum) =~? '\v^\s*$'
     if (strlen(matchstr(getline(a:lnum + 1), '^' . '=' . '\+')) > 0 && !0)
       return '-1' " don't fold last blank line before header
     endif
   endif
   return '=' " return previous fold level
 endfunction


""" vim-wiki
"" can consider keeping global mappings → currently testing fzf as replacement
"let g:vimwiki_list = [{ 'path': '~/Documents/notes/' }]
"let g:vimwiki_key_mappings =
"  \ {
"  \   'all_maps': 1,
"  \   'global': 0,
"  \   'headers': 1,
"  \   'text_objs': 1,
"  \   'table_format': 1,
"  \   'table_mappings': 1,
"  \   'lists': 1,
"  \   'links': 0,
"  \   'html': 0,
"  \   'mouse': 0,
"  \ }
"
"let g:tagbar_type_vimwiki = {
"			\   'ctagstype':'vimwiki'
"			\ , 'kinds':['h:header']
"			\ , 'sro':'&&&'
"			\ , 'kind2scope':{'h':'header'}
"			\ , 'sort':0
"			\ , 'ctagsbin':'/home/stephen/.vim/bundle/markdown2ctags/vwtags.py'
"			\ , 'ctagsargs': 'default'
"			\ }
"let g:vimwiki_folding = 'custom'
"augroup AutoSaveFolds                  " Autosave and reload vimwiki folds
"  autocmd!
"  autocmd BufWinLeave *.wiki mkview
"  autocmd BufWinEnter *.wiki silent loadview
"augroup END
"
"autocmd FileType vimwiki nnoremap <buffer> <silent><tab> :VimwikiNextLink<cr>
"autocmd FileType vimwiki nnoremap <buffer> <silent><s-tab> :VimwikiPrevLink<cr>
"autocmd FileType vimwiki nnoremap <buffer> <cr> :VimwikiFollowLink<cr>
"autocmd FileType vimwiki inoremap <buffer> ( ()<Left>
"autocmd FileType vimwiki inoremap <buffer> " ""<Left>


"" vim-wiki
let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin':'/home/stephen/.vim/bundle/markdown2ctags/vwtags.py'
			\ , 'ctagsargs': 'default'
			\ }
let g:vimwiki_folding = 'custom'
augroup AutoSaveFolds                  " Autosave and reload vimwiki folds
  autocmd!
  autocmd BufWinLeave *.wiki mkview
  autocmd BufWinEnter *.wiki silent loadview
augroup END

nnoremap <buffer> <silent><tab> :VimwikiNextLink<cr>
nnoremap <buffer> <silent><s-tab> :VimwikiPrevLink<cr>
nnoremap <buffer> <cr> :VimwikiFollowLink<cr>
inoremap <buffer> ( ()<Left>
inoremap <buffer> " ""<Left>

" Vimwiki abbrieviations
ab <buffer> hte the
ab <buffer> htey they
ab <buffer> nad and
ab <buffer> ofr for
ab <buffer> ot to
ab <buffer> ont not
ab <buffer> ohter other
ab <buffer> tho though
ab <buffer> thru through
ab <buffer> w with
ab <buffer> isnt isn't
ab <buffer> cant can't
ab <buffer> dont don't
ab <buffer> wouldnt wouldn't
ab <buffer> wo without
ab <buffer> bc because
ab <buffer> bw between
ab <buffer> diff different
ab <buffer> ppl people
ab <buffer> rxn reaction
ab <buffer> def definitely
ab <buffer> prb probability
ab <buffer> prob probably
ab <buffer> pi π
ab <buffer> theta θ
ab <buffer> Delta Δ
ab <buffer> mu μ
ab <buffer> dg °
ab <buffer> <> ⇌
ab <buffer> url [[link\|desc] ]<esc>10h
ab <buffer> img {{file_url} }<esc>7h

