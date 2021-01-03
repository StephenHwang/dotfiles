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


"" mappings
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
ab <buffer> bf before
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
