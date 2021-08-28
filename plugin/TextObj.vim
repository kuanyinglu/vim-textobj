let g:quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '[', 'closing': ']' }, { 'opening': '<', 'closing': '\(=\)\@<!>' }, { 'opening': '(', 'closing': ')' }]
let g:tagPatterns = { 'es': '<\_[^/]\{-}\(=\)\@<!\zs>', 'se': '<\ze\/\_[^/]\{-}\(=\)\@<!>', 'ss': '<\ze\_[^/]\{-}\(=\)\@<!>', 'ee': '<\/\_[^/]\{-}\(=\)\@<!\zs>' }
let g:spacePatterns = { 'first': '\(\(\S\)\@<=\s\{-1}\)\|\(\(\_^\)\@<=\s\{-1}\)', 'last': '\zs\s\{-1}\ze\_S' }
" -matches html start tags <\_[^/]\{-}\(=\)\@<!>
" -matches htm end tags <\/\_[^/]\{-}\(=\)\@<!>

" 0 - normal mode, forward, end
" 1 - normal mode, backward, end
" 2 - normal mode, forward, start
" 3 - normal mode, backward, start
" 4 - visual mode, forward, end
" 5 - visual mode, backward, end
" 6 - visual mode, forward, start
" 7 - visual mode, backward, start
" 8 - normal mode, forward, end, inner
" 9 - normal mode, backward, end, inner
" 10 - normal mode, forward, start, inner
" 11 - normal mode, backward, start, inner
" 12 - visual mode, forward, end, inner
" 13 - visual mode, backward, end, inner
" 14 - visual mode, forward, start, inner
" 15 - visual mode, backward, start, inner
" 16 - visual mode, trim
" 17 - visual mode, expand
" 18 - op mode, forward
" 19 - op mode, backward
" 20 - op mode, current
nmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  0)<cr>
nmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  1)<cr>
nmap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  2)<cr>
nmap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  3)<cr>
vmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  4)<cr>
vmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  5)<cr>
vmap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  6)<cr>
vmap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  7)<cr>
nmap ]iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  8)<cr>
nmap [iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  9)<cr>
nmap ]iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  10)<cr>
nmap [iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  11)<cr>
vmap ]iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  12)<cr>
vmap [iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  13)<cr>
vmap ]iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  14)<cr>
vmap [iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  15)<cr>
nmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  0)<cr>
nmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  1)<cr>
nmap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  2)<cr>
nmap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  3)<cr>
vmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  4)<cr>
vmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  5)<cr>
vmap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  6)<cr>
vmap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  7)<cr>
nmap ]ib :<c-u>call txtObj#Move('move#pair#GetPairs',  8)<cr>
nmap [ib :<c-u>call txtObj#Move('move#pair#GetPairs',  9)<cr>
nmap ]iB :<c-u>call txtObj#Move('move#pair#GetPairs',  10)<cr>
nmap [iB :<c-u>call txtObj#Move('move#pair#GetPairs',  11)<cr>
vmap ]ib :<c-u>call txtObj#Move('move#pair#GetPairs',  12)<cr>
vmap [ib :<c-u>call txtObj#Move('move#pair#GetPairs',  13)<cr>
vmap ]iB :<c-u>call txtObj#Move('move#pair#GetPairs',  14)<cr>
vmap [iB :<c-u>call txtObj#Move('move#pair#GetPairs',  15)<cr>
nmap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  0)<cr>
nmap [t :<c-u>call txtObj#Move('move#tag#GetTags',  1)<cr>
nmap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  2)<cr>
nmap [T :<c-u>call txtObj#Move('move#tag#GetTags',  3)<cr>
vmap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  4)<cr>
vmap [t :<c-u>call txtObj#Move('move#tag#GetTags',  5)<cr>
vmap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  6)<cr>
vmap [T :<c-u>call txtObj#Move('move#tag#GetTags',  7)<cr>
nmap ]it :<c-u>call txtObj#Move('move#tag#GetTags',  8)<cr>
nmap [it :<c-u>call txtObj#Move('move#tag#GetTags',  9)<cr>
nmap ]iT :<c-u>call txtObj#Move('move#tag#GetTags',  10)<cr>
nmap [iT :<c-u>call txtObj#Move('move#tag#GetTags',  11)<cr>
vmap ]it :<c-u>call txtObj#Move('move#tag#GetTags',  12)<cr>
vmap [it :<c-u>call txtObj#Move('move#tag#GetTags',  13)<cr>
vmap ]iT :<c-u>call txtObj#Move('move#tag#GetTags',  14)<cr>
vmap [iT :<c-u>call txtObj#Move('move#tag#GetTags',  15)<cr>
nmap ]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  0)<cr>
nmap [<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  1)<cr>
nmap ]]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  2)<cr>
nmap [[<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  3)<cr>
vmap ]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  4)<cr>
vmap [<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  5)<cr>
vmap ]]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  6)<cr>
vmap [[<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  7)<cr>