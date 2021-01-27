" vimwiki folding adopted from
" https://vimwiki.github.io/vimwikiwiki/Tips%20and%20Snips.html
setlocal foldlevel=99
setlocal foldenable
setlocal foldmethod=expr
setlocal foldexpr=Fold(v:lnum)

" Fold function
function! Fold(lnum)
  let fold_level = strlen(matchstr(getline(a:lnum), '^' . '=' . '\+'))
  if (fold_level)
    return '>' . fold_level  " start a fold level
  endif
  if getline(a:lnum) =~? '\v^\s*$'
    " set !1 to fold blank lines set !0 to not fold blank lines
    if (strlen(matchstr(getline(a:lnum + 1), '^' . '=' . '\+')) > 0 && !1)
      return '-1'       " don't fold last blank line before header
    endif
  endif
  return '='            " return previous fold level
endfunction

" save vimwiki folds between sessions
augroup save_vimwiki_folds
  autocmd!
  autocmd BufWinLeave *.wiki mkview
  autocmd BufWinEnter *.wiki silent loadview
augroup END

" mappings
nnoremap <buffer> <silent><tab> :VimwikiNextLink<cr>
nnoremap <buffer> <silent><s-tab> :VimwikiPrevLink<cr>
nnoremap <buffer> <cr> :VimwikiFollowLink<cr>

" toggle checkbox with dot command to next line
map <silent><Plug>ReToggleListMap :VimwikiToggleListItem<cr>:norm j<cr>:call repeat#set("\<Plug>ReToggleListMap", v:count)<cr>
map <silent><Plug>ToggleListMap :VimwikiToggleListItem<cr>:call repeat#set("\<Plug>ReToggleListMap", v:count)<cr>
nmap <leader>f <Plug>ToggleListMap
vmap <leader>f <Plug>ToggleListMap

" url and img embedding
ab <buffer> url [[link\|desc] ]<esc>10h
ab <buffer> img {{file_url} }<esc>7h

" complete quotations
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
ab <buffer> bf before
ab <buffer> wo without
ab <buffer> bc because
ab <buffer> bw between
ab <buffer> diff different
ab <buffer> cont continue
ab <buffer> ppl people

ab <buffer> isnt isn't
ab <buffer> cant can't
ab <buffer> dont don't
ab <buffer> didt did't
ab <buffer> wont won't
ab <buffer> wouldnt wouldn't

ab <buffer> rxn reaction
ab <buffer> def definitely
ab <buffer> prb probability
ab <buffer> prob probably
ab <buffer> dist distribution

ab <buffer> pi π
ab <buffer> theta θ
ab <buffer> Delta Δ
ab <buffer> mu μ
ab <buffer> dg °
ab <buffer> omega Ω 
ab <buffer> <> ⇌

