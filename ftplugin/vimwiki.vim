" vimwiki folding adopted from
" https://vimwiki.github.io/vimwikiwiki/Tips%20and%20Snips.html
setlocal foldlevel=99
setlocal foldenable
setlocal foldexpr=Fold(v:lnum)
setlocal foldmethod=expr

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

" Change to bullet or toggle checkbox function
function! MakeListToggleList()
  if getline('.') =~ '^\s*$'        " Skip empty line
    return
  endif
  if getline('.') =~ '^\s*\d\+. '     " toggle numerical list checkbox
    :VimwikiToggleListItem
    return
  endif
  if getline('.') =~ '^\s*- '       " toggle normal list item checkbox
    :VimwikiToggleListItem
  else
    norm I- 
  end
endfunction

" Toggle checkbox with dot command to next line
map <silent><Plug>ReToggleListMap :call MakeListToggleList()<cr>:norm j<cr>:call repeat#set("\<Plug>ReToggleListMap", v:count)<cr>
map <silent><Plug>ToggleListMap :call MakeListToggleList()<cr>:call repeat#set("\<Plug>ReToggleListMap", v:count)<cr>

" Toggle list checkbox
nmap <leader>f <Plug>ToggleListMap
vmap <leader>f <Plug>ToggleListMap

let g:tagbar_type_vimwiki = {
			\   'ctagstype':'vimwiki'
			\ , 'kinds':['h:header']
			\ , 'sro':'&&&'
			\ , 'kind2scope':{'h':'header'}
			\ , 'sort':0
			\ , 'ctagsbin': '/home/stephen/bin/ctags-5.8/vwtags.py'
			\ , 'ctagsargs': 'default'
			\ }

" Mappings
function! VWLink()
  VimwikiNextLink
endfunction
map <silent><Plug>VWLinkMap :call VWLink()<cr>:call repeat#set("\<Plug>VWLinkMap", v:count)<cr>
nmap <leader>y <Plug>VWLinkMap
nnoremap <buffer> <silent> <leader>Y :VimwikiPrevLink<cr>
nnoremap gf :VimwikiFollowLink<cr>


" complete quotations
" inoremap <buffer> " ""<Left>

" url and img embedding
iabbr <buffer> url [[link\|desc] ]<esc>10h
iabbr <buffer> img {{file_url} }<esc>7h

" Vimwiki abbrieviations
iabbr <buffer> hte the
iabbr <buffer> htey they
iabbr <buffer> nad and
iabbr <buffer> ofr for
iabbr <buffer> ot to
iabbr <buffer> ont not
iabbr <buffer> ohter other
iabbr <buffer> tho though
iabbr <buffer> thru through
iabbr <buffer> w with
iabbr <buffer> bf before
iabbr <buffer> wo without
iabbr <buffer> bc because
iabbr <buffer> bw between
iabbr <buffer> diff different
iabbr <buffer> cont continue
iabbr <buffer> ppl people

iabbr <buffer> isnt isn't
iabbr <buffer> cant can't
iabbr <buffer> dont don't
iabbr <buffer> didnt didn't
iabbr <buffer> wont won't
iabbr <buffer> wouldnt wouldn't

iabbr <buffer> rxn reaction
iabbr <buffer> def definitely
iabbr <buffer> prb probability
iabbr <buffer> prob probably
iabbr <buffer> distr distribution

iabbr <buffer> pi π
iabbr <buffer> theta θ
iabbr <buffer> Delta Δ
iabbr <buffer> mu μ
iabbr <buffer> dg °
iabbr <buffer> omega Ω 
iabbr <buffer> <> ⇌
