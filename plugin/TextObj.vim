let g:TextObj_spacePatterns = { 'first': '\(\(\S\)\@<=\s\{-1}\)\|\(\(\_^\)\@<=\s\{-1}\)', 'last': '\zs\s\{-1}\ze\_S' }
let g:TextObj_quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:TextObj_blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '\[', 'closing': '\]' }, { 'opening': '<', 'closing': '\(=\)\@<!>' }, { 'opening': '(', 'closing': ')' }]
let g:TextObj_tagPatterns = { 'es': '<\_[^/]\{-}\(=\)\@<!\zs>', 'se': '<\ze\/\_[^/]\{-}\(=\)\@<!>', 'ss': '<\ze\_[^/]\{-}\(=\)\@<!>', 'ee': '<\/\_[^/]\{-}\(=\)\@<!\zs>' }

let g:TextObj_constant_nonword = '[^a-zA-Z0-9\-_]'
let g:TextObj_constant_word = '[a-zA-Z0-9\-_]'
let g:TextObj_constant_lower = '[a-z]'
let g:TextObj_constant_cap = '[A-Z]'
let g:TextObj_constant_connector = '[\-_]'
let g:TextObj_constant_number = '[0-9]'
let s:subwordArray = [g:TextObj_constant_lower, g:TextObj_constant_cap, g:TextObj_constant_connector, g:TextObj_constant_number]
let s:subwordOpening = '\%^' . g:TextObj_constant_word . '\|' . '\%([\n]\)\@<=' . g:TextObj_constant_word . '\|\%(' . g:TextObj_constant_nonword . '\)\@<=' . g:TextObj_constant_word . '\|\%(' . g:TextObj_constant_cap . '\)\@<=' . g:TextObj_constant_cap . '\%(' . g:TextObj_constant_lower . '\)\@='
for i in [0, 1, 2, 3]
    for j in [0, 1, 2, 3]
"Captial going into lower case is the same word
        if j != i && !(i == 1 && j == 0)
            let s:subwordOpening = s:subwordOpening . '\|\%(' . s:subwordArray[i] . '\)\@<=' . s:subwordArray[j]
        endif
    endfor
endfor
let s:subwordClosing = g:TextObj_constant_word . '\%$' . '\|' . g:TextObj_constant_word . '\%([\n]\)\@=' . '\|' . g:TextObj_constant_word . '\%(' . g:TextObj_constant_nonword . '\)\@=' . '\|' . g:TextObj_constant_cap . '\%(' . g:TextObj_constant_cap . g:TextObj_constant_lower . '\)\@='
for i in [0, 1, 2, 3]
    for j in [0, 1, 2, 3]
        if j != i && !(i == 1 && j == 0)
            let s:subwordClosing = s:subwordClosing . '\|' . s:subwordArray[i] . '\%(' . s:subwordArray[j] . '\)\@='
        endif
    endfor
endfor

let s:wordOpening = '\%^' . g:TextObj_constant_word . '\|' . '\%([\n]\)\@<=' . g:TextObj_constant_word . '\|\%(' . g:TextObj_constant_nonword . '\)\@<=' . g:TextObj_constant_word
let s:wordClosing = g:TextObj_constant_word . '\%$' . '\|' . g:TextObj_constant_word . '\%([\n]\)\@=' . '\|' . g:TextObj_constant_word . '\%(' . g:TextObj_constant_nonword . '\)\@='
let g:TextObj_wordPatterns = { 'opening': s:wordOpening, 'closing': s:wordClosing }
let g:TextObj_subwordPatterns = { 'opening': s:subwordOpening, 'closing': s:subwordClosing }

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
" 16 - visual mode, expand
" 17 - visual mode, trim
" 18 - visual mode, expand, inner
" 19 - visual mode, trim, inner
" 20 - op mode, forward, end
" 21 - op mode, backward, end
" 22 - op mode, forward, start
" 23 - op mode, backward, start
" 24 - op mode, forward, end, inner
" 25 - op mode, backward, end, inner
" 26 - op mode, forward, start, inner
" 27 - op mode, backward, start, inner
" 28 - op mode, current
" 29 - op mode, current, inner
" 30 - normal mode, current
" 31 - normal mode, current, inner

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
nmap ]s :<c-u>call txtObj#Move('move#subword#GetSubWords',  0)<cr>
nmap [s :<c-u>call txtObj#Move('move#subword#GetSubWords',  1)<cr>
nmap ]S :<c-u>call txtObj#Move('move#subword#GetSubWords',  2)<cr>
nmap [S :<c-u>call txtObj#Move('move#subword#GetSubWords',  3)<cr>
vmap ]s :<c-u>call txtObj#Move('move#subword#GetSubWords',  4)<cr>
vmap [s :<c-u>call txtObj#Move('move#subword#GetSubWords',  5)<cr>
vmap ]S :<c-u>call txtObj#Move('move#subword#GetSubWords',  6)<cr>
vmap [S :<c-u>call txtObj#Move('move#subword#GetSubWords',  7)<cr>
nmap ]w :<c-u>call txtObj#Move('move#word#GetWords',  0)<cr>
nmap [w :<c-u>call txtObj#Move('move#word#GetWords',  1)<cr>
nmap ]W :<c-u>call txtObj#Move('move#word#GetWords',  2)<cr>
nmap [W :<c-u>call txtObj#Move('move#word#GetWords',  3)<cr>
vmap ]w :<c-u>call txtObj#Move('move#word#GetWords',  4)<cr>
vmap [w :<c-u>call txtObj#Move('move#word#GetWords',  5)<cr>
vmap ]W :<c-u>call txtObj#Move('move#word#GetWords',  6)<cr>
vmap [W :<c-u>call txtObj#Move('move#word#GetWords',  7)<cr>

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
omap ]s :<c-u>call txtObj#Op('move#subword#GetSubWords',  20)<cr>
omap [s :<c-u>call txtObj#Op('move#subword#GetSubWords',  21)<cr>
omap ]S :<c-u>call txtObj#Op('move#subword#GetSubWords',  22)<cr>
omap [S :<c-u>call txtObj#Op('move#subword#GetSubWords',  23)<cr>
omap ]w :<c-u>call txtObj#Op('move#word#GetWords',  20)<cr>
omap [w :<c-u>call txtObj#Op('move#word#GetWords',  21)<cr>
omap ]W :<c-u>call txtObj#Op('move#word#GetWords',  22)<cr>
omap [W :<c-u>call txtObj#Op('move#word#GetWords',  23)<cr>

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
vmap }s :<c-u>call txtObj#Scale('scale#subword#GetSubWords',  16)<cr>
vmap {s :<c-u>call txtObj#Scale('scale#subword#GetSubWords',  17)<cr>
vmap }w :<c-u>call txtObj#Scale('scale#word#GetWords',  16)<cr>
vmap {w :<c-u>call txtObj#Scale('scale#word#GetWords',  17)<cr>

"Current Cursor
omap aq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  28)<cr>
omap iq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  29)<cr>
nmap vaq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  30)<cr>
nmap viq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  31)<cr>
omap ab :<c-u>call txtObj#Current('scale#pair#GetPairs',  28)<cr>
omap ib :<c-u>call txtObj#Current('scale#pair#GetPairs',  29)<cr>
nmap vab :<c-u>call txtObj#Current('scale#pair#GetPairs',  30)<cr>
nmap vib :<c-u>call txtObj#Current('scale#pair#GetPairs',  31)<cr>
omap at :<c-u>call txtObj#Current('scale#tag#GetTags',  28)<cr>
omap it :<c-u>call txtObj#Current('scale#tag#GetTags',  29)<cr>
nmap vat :<c-u>call txtObj#Current('scale#tag#GetTags',  30)<cr>
nmap vit :<c-u>call txtObj#Current('scale#tag#GetTags',  31)<cr>
omap a<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  28)<cr>
omap i<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  29)<cr>
nmap va<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  30)<cr>
nmap vi<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  31)<cr>
omap s :<c-u>call txtObj#Current('scale#subword#GetSubWords',  28)<cr>
nmap vs :<c-u>call txtObj#Current('scale#subword#GetSubWords',  30)<cr>
omap w :<c-u>call txtObj#Current('scale#word#GetWords',  28)<cr>
nmap vw :<c-u>call txtObj#Current('scale#word#GetWords',  30)<cr>