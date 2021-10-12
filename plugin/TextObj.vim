let g:quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '\[', 'closing': '\]' }, { 'opening': '<', 'closing': '\(=\)\@<!>' }, { 'opening': '(', 'closing': ')' }]
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
" 18 - op mode, forward, end
" 19 - op mode, backward, end
" 20 - op mode, forward, start
" 21 - op mode, backward, start
" 22 - op mode, forward, end, inner
" 23 - op mode, backward, end, inner
" 24 - op mode, forward, start, inner
" 25 - op mode, backward, start, inner
" 26 - op mode, current

"Normal and visual mode move
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

"Operator pending mode

omap ]q :<c-u>call txtObj#Op('move#quote#GetQuotes',  20)<cr>
omap [q :<c-u>call txtObj#Op('move#quote#GetQuotes',  21)<cr>
omap ]Q :<c-u>call txtObj#Op('move#quote#GetQuotes',  22)<cr>
omap [Q :<c-u>call txtObj#Op('move#quote#GetQuotes',  23)<cr>
omap ]iq :<c-u>call txtObj#Op('move#quote#GetQuotes',  24)<cr>
omap [iq :<c-u>call txtObj#Op('move#quote#GetQuotes',  25)<cr>
omap ]iQ :<c-u>call txtObj#Op('move#quote#GetQuotes',  26)<cr>
omap [iQ :<c-u>call txtObj#Op('move#quote#GetQuotes',  27)<cr>
omap ]b :<c-u>call txtObj#Op('move#pair#GetPairs',  20)<cr>
omap [b :<c-u>call txtObj#Op('move#pair#GetPairs',  21)<cr>
omap ]B :<c-u>call txtObj#Op('move#pair#GetPairs',  22)<cr>
omap [B :<c-u>call txtObj#Op('move#pair#GetPairs',  23)<cr>
omap ]ib :<c-u>call txtObj#Op('move#pair#GetPairs',  24)<cr>
omap [ib :<c-u>call txtObj#Op('move#pair#GetPairs',  25)<cr>
omap ]iB :<c-u>call txtObj#Op('move#pair#GetPairs',  26)<cr>
omap [iB :<c-u>call txtObj#Op('move#pair#GetPairs',  27)<cr>
omap ]t :<c-u>call txtObj#Op('move#tag#GetTags',  20)<cr>
omap [t :<c-u>call txtObj#Op('move#tag#GetTags',  21)<cr>
omap ]T :<c-u>call txtObj#Op('move#tag#GetTags',  22)<cr>
omap [T :<c-u>call txtObj#Op('move#tag#GetTags',  23)<cr>
omap ]it :<c-u>call txtObj#Op('move#tag#GetTags',  24)<cr>
omap [it :<c-u>call txtObj#Op('move#tag#GetTags',  25)<cr>
omap ]iT :<c-u>call txtObj#Op('move#tag#GetTags',  26)<cr>
omap [iT :<c-u>call txtObj#Op('move#tag#GetTags',  27)<cr>
omap ]<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 20)<cr>
omap [<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 21)<cr>
omap ]]<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 22)<cr>
omap [[<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 23)<cr>

"Expand, shrink
map { <nop>
map } <nop>
vmap }b :<c-u>call txtObj#Scale('scale#pair#GetPairs',  16)<cr>
vmap {b :<c-u>call txtObj#Scale('scale#pair#GetPairs',  17)<cr>
vmap }ib :<c-u>call txtObj#Scale('scale#pair#GetPairs',  18)<cr>
vmap {ib :<c-u>call txtObj#Scale('scale#pair#GetPairs',  19)<cr>
vmap }q :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  16)<cr>
vmap {q :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  17)<cr>
vmap }iq :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  18)<cr>
vmap {iq :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  19)<cr>
vmap }t :<c-u>call txtObj#Scale('scale#tag#GetTags',  16)<cr>
vmap {t :<c-u>call txtObj#Scale('scale#tag#GetTags',  17)<cr>
vmap }it :<c-u>call txtObj#Scale('scale#tag#GetTags',  18)<cr>
vmap {it :<c-u>call txtObj#Scale('scale#tag#GetTags',  19)<cr>
vmap }<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  16)<cr>
vmap {<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  17)<cr>
vmap }i<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  18)<cr>
vmap {i<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  19)<cr>