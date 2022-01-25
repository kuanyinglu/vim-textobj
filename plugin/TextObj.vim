let g:TextObj_spacePatterns = { 'first': '\(\(\S\)\@<=\s\{-1}\)\|\(\(\_^\)\@<=\s\{-1}\)', 'last': '\zs\s\{-1}\ze\_S' }
let g:TextObj_quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:TextObj_blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '\[', 'closing': '\]' }, { 'opening': '<', 'closing': '\(=\)\@<!>' }, { 'opening': '(', 'closing': ')' }]
let g:TextObj_tagPatterns = { 'tagOpening': '<[^ \t>/!?]\+\%(\_s\_[^>]\{-}[^/]>\|\_s\=>\)', 'endTagName': '<\/\=[^ \t>/!]\+\zs[^ \t>/!]\ze[>]\{-,1}', 'tagClosing' : '<\/[^ \t>/!]\+\%(\_s\_[^>]\{-}[^/]>\|\_s\=>\)', 'tagClosingInverted': '<\/[^ \t>/!]\+\%(\_s\_[^>]\{-}[^/]\|\_s\=\)\zs>', 'tagOpeningInverted': '<[^ \t>/!?]\+\%(\_s\_[^>]\{-}[^/]\|\_s\=\)\zs>'}

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

if !exists('g:TextObj_setMapping')
    "Normal and visual mode move
    nnoremap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  0)<cr>
    nnoremap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  1)<cr>
    nnoremap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  2)<cr>
    nnoremap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  3)<cr>
    vnoremap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  4)<cr>
    vnoremap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  5)<cr>
    vnoremap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  6)<cr>
    vnoremap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  7)<cr>
    nnoremap ]iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  8)<cr>
    nnoremap [iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  9)<cr>
    nnoremap ]iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  10)<cr>
    nnoremap [iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  11)<cr>
    vnoremap ]iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  12)<cr>
    vnoremap [iq :<c-u>call txtObj#Move('move#quote#GetQuotes',  13)<cr>
    vnoremap ]iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  14)<cr>
    vnoremap [iQ :<c-u>call txtObj#Move('move#quote#GetQuotes',  15)<cr>
    nnoremap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  0)<cr>
    nnoremap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  1)<cr>
    nnoremap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  2)<cr>
    nnoremap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  3)<cr>
    vnoremap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  4)<cr>
    vnoremap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  5)<cr>
    vnoremap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  6)<cr>
    vnoremap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  7)<cr>
    nnoremap ]ib :<c-u>call txtObj#Move('move#pair#GetPairs',  8)<cr>
    nnoremap [ib :<c-u>call txtObj#Move('move#pair#GetPairs',  9)<cr>
    nnoremap ]iB :<c-u>call txtObj#Move('move#pair#GetPairs',  10)<cr>
    nnoremap [iB :<c-u>call txtObj#Move('move#pair#GetPairs',  11)<cr>
    vnoremap ]ib :<c-u>call txtObj#Move('move#pair#GetPairs',  12)<cr>
    vnoremap [ib :<c-u>call txtObj#Move('move#pair#GetPairs',  13)<cr>
    vnoremap ]iB :<c-u>call txtObj#Move('move#pair#GetPairs',  14)<cr>
    vnoremap [iB :<c-u>call txtObj#Move('move#pair#GetPairs',  15)<cr>
    nnoremap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  0)<cr>
    nnoremap [t :<c-u>call txtObj#Move('move#tag#GetTags',  1)<cr>
    nnoremap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  2)<cr>
    nnoremap [T :<c-u>call txtObj#Move('move#tag#GetTags',  3)<cr>
    vnoremap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  4)<cr>
    vnoremap [t :<c-u>call txtObj#Move('move#tag#GetTags',  5)<cr>
    vnoremap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  6)<cr>
    vnoremap [T :<c-u>call txtObj#Move('move#tag#GetTags',  7)<cr>
    nnoremap ]it :<c-u>call txtObj#Move('move#tag#GetTags',  8)<cr>
    nnoremap [it :<c-u>call txtObj#Move('move#tag#GetTags',  9)<cr>
    nnoremap ]iT :<c-u>call txtObj#Move('move#tag#GetTags',  10)<cr>
    nnoremap [iT :<c-u>call txtObj#Move('move#tag#GetTags',  11)<cr>
    vnoremap ]it :<c-u>call txtObj#Move('move#tag#GetTags',  12)<cr>
    vnoremap [it :<c-u>call txtObj#Move('move#tag#GetTags',  13)<cr>
    vnoremap ]iT :<c-u>call txtObj#Move('move#tag#GetTags',  14)<cr>
    vnoremap [iT :<c-u>call txtObj#Move('move#tag#GetTags',  15)<cr>
    nnoremap ]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  0)<cr>
    nnoremap [<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  1)<cr>
    nnoremap ]]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  2)<cr>
    nnoremap [[<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  3)<cr>
    vnoremap ]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  4)<cr>
    vnoremap [<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  5)<cr>
    vnoremap ]]<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  6)<cr>
    vnoremap [[<space> :<c-u>call txtObj#Move('move#space#GetSpaces',  7)<cr>
    nnoremap ]s :<c-u>call txtObj#Move('move#subword#GetSubWords',  0)<cr>
    nnoremap [s :<c-u>call txtObj#Move('move#subword#GetSubWords',  1)<cr>
    nnoremap ]S :<c-u>call txtObj#Move('move#subword#GetSubWords',  2)<cr>
    nnoremap [S :<c-u>call txtObj#Move('move#subword#GetSubWords',  3)<cr>
    vnoremap ]s :<c-u>call txtObj#Move('move#subword#GetSubWords',  4)<cr>
    vnoremap [s :<c-u>call txtObj#Move('move#subword#GetSubWords',  5)<cr>
    vnoremap ]S :<c-u>call txtObj#Move('move#subword#GetSubWords',  6)<cr>
    vnoremap [S :<c-u>call txtObj#Move('move#subword#GetSubWords',  7)<cr>
    nnoremap ]w :<c-u>call txtObj#Move('move#word#GetWords',  0)<cr>
    nnoremap [w :<c-u>call txtObj#Move('move#word#GetWords',  1)<cr>
    nnoremap ]W :<c-u>call txtObj#Move('move#word#GetWords',  2)<cr>
    nnoremap [W :<c-u>call txtObj#Move('move#word#GetWords',  3)<cr>
    vnoremap ]w :<c-u>call txtObj#Move('move#word#GetWords',  4)<cr>
    vnoremap [w :<c-u>call txtObj#Move('move#word#GetWords',  5)<cr>
    vnoremap ]W :<c-u>call txtObj#Move('move#word#GetWords',  6)<cr>
    vnoremap [W :<c-u>call txtObj#Move('move#word#GetWords',  7)<cr>

    "Operator pending mode
    onoremap ]q :<c-u>call txtObj#Op('move#quote#GetQuotes',  20)<cr>
    onoremap [q :<c-u>call txtObj#Op('move#quote#GetQuotes',  21)<cr>
    onoremap ]Q :<c-u>call txtObj#Op('move#quote#GetQuotes',  22)<cr>
    onoremap [Q :<c-u>call txtObj#Op('move#quote#GetQuotes',  23)<cr>
    onoremap ]iq :<c-u>call txtObj#Op('move#quote#GetQuotes',  24)<cr>
    onoremap [iq :<c-u>call txtObj#Op('move#quote#GetQuotes',  25)<cr>
    onoremap ]iQ :<c-u>call txtObj#Op('move#quote#GetQuotes',  26)<cr>
    onoremap [iQ :<c-u>call txtObj#Op('move#quote#GetQuotes',  27)<cr>
    onoremap ]b :<c-u>call txtObj#Op('move#pair#GetPairs',  20)<cr>
    onoremap [b :<c-u>call txtObj#Op('move#pair#GetPairs',  21)<cr>
    onoremap ]B :<c-u>call txtObj#Op('move#pair#GetPairs',  22)<cr>
    onoremap [B :<c-u>call txtObj#Op('move#pair#GetPairs',  23)<cr>
    onoremap ]ib :<c-u>call txtObj#Op('move#pair#GetPairs',  24)<cr>
    onoremap [ib :<c-u>call txtObj#Op('move#pair#GetPairs',  25)<cr>
    onoremap ]iB :<c-u>call txtObj#Op('move#pair#GetPairs',  26)<cr>
    onoremap [iB :<c-u>call txtObj#Op('move#pair#GetPairs',  27)<cr>
    onoremap ]t :<c-u>call txtObj#Op('move#tag#GetTags',  20)<cr>
    onoremap [t :<c-u>call txtObj#Op('move#tag#GetTags',  21)<cr>
    onoremap ]T :<c-u>call txtObj#Op('move#tag#GetTags',  22)<cr>
    onoremap [T :<c-u>call txtObj#Op('move#tag#GetTags',  23)<cr>
    onoremap ]it :<c-u>call txtObj#Op('move#tag#GetTags',  24)<cr>
    onoremap [it :<c-u>call txtObj#Op('move#tag#GetTags',  25)<cr>
    onoremap ]iT :<c-u>call txtObj#Op('move#tag#GetTags',  26)<cr>
    onoremap [iT :<c-u>call txtObj#Op('move#tag#GetTags',  27)<cr>
    onoremap ]<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 20)<cr>
    onoremap [<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 21)<cr>
    onoremap ]]<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 22)<cr>
    onoremap [[<space> :<c-u>call txtObj#Op('move#space#GetSpaces', 23)<cr>
    onoremap ]s :<c-u>call txtObj#Op('move#subword#GetSubWords',  20)<cr>
    onoremap [s :<c-u>call txtObj#Op('move#subword#GetSubWords',  21)<cr>
    onoremap ]S :<c-u>call txtObj#Op('move#subword#GetSubWords',  22)<cr>
    onoremap [S :<c-u>call txtObj#Op('move#subword#GetSubWords',  23)<cr>
    onoremap ]w :<c-u>call txtObj#Op('move#word#GetWords',  20)<cr>
    onoremap [w :<c-u>call txtObj#Op('move#word#GetWords',  21)<cr>
    onoremap ]W :<c-u>call txtObj#Op('move#word#GetWords',  22)<cr>
    onoremap [W :<c-u>call txtObj#Op('move#word#GetWords',  23)<cr>

    "Expand, shrink
    map { <nop>
    map } <nop>
    vnoremap }b :<c-u>call txtObj#Scale('scale#pair#GetPairs',  16)<cr>
    vnoremap {b :<c-u>call txtObj#Scale('scale#pair#GetPairs',  17)<cr>
    vnoremap }ib :<c-u>call txtObj#Scale('scale#pair#GetPairs',  18)<cr>
    vnoremap {ib :<c-u>call txtObj#Scale('scale#pair#GetPairs',  19)<cr>
    vnoremap }q :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  16)<cr>
    vnoremap {q :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  17)<cr>
    vnoremap }iq :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  18)<cr>
    vnoremap {iq :<c-u>call txtObj#Scale('scale#quote#GetQuotes',  19)<cr>
    vnoremap }t :<c-u>call txtObj#Scale('scale#tag#GetTags',  16)<cr>
    vnoremap {t :<c-u>call txtObj#Scale('scale#tag#GetTags',  17)<cr>
    vnoremap }it :<c-u>call txtObj#Scale('scale#tag#GetTags',  18)<cr>
    vnoremap {it :<c-u>call txtObj#Scale('scale#tag#GetTags',  19)<cr>
    vnoremap }<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  16)<cr>
    vnoremap {<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  17)<cr>
    vnoremap }i<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  18)<cr>
    vnoremap {i<space> :<c-u>call txtObj#Scale('scale#space#GetSpaces',  19)<cr>
    vnoremap }s :<c-u>call txtObj#Scale('scale#subword#GetSubWords',  16)<cr>
    vnoremap {s :<c-u>call txtObj#Scale('scale#subword#GetSubWords',  17)<cr>
    vnoremap }w :<c-u>call txtObj#Scale('scale#word#GetWords',  16)<cr>
    vnoremap {w :<c-u>call txtObj#Scale('scale#word#GetWords',  17)<cr>

    "Current Cursor
    onoremap aq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  28)<cr>
    onoremap iq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  29)<cr>
    nnoremap vaq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  30)<cr>
    nnoremap viq :<c-u>call txtObj#Current('scale#quote#GetQuotes',  31)<cr>
    onoremap ab :<c-u>call txtObj#Current('scale#pair#GetPairs',  28)<cr>
    onoremap ib :<c-u>call txtObj#Current('scale#pair#GetPairs',  29)<cr>
    nnoremap vab :<c-u>call txtObj#Current('scale#pair#GetPairs',  30)<cr>
    nnoremap vib :<c-u>call txtObj#Current('scale#pair#GetPairs',  31)<cr>
    onoremap at :<c-u>call txtObj#Current('scale#tag#GetTags',  28)<cr>
    onoremap it :<c-u>call txtObj#Current('scale#tag#GetTags',  29)<cr>
    nnoremap vat :<c-u>call txtObj#Current('scale#tag#GetTags',  30)<cr>
    nnoremap vit :<c-u>call txtObj#Current('scale#tag#GetTags',  31)<cr>
    onoremap a<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  28)<cr>
    onoremap i<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  29)<cr>
    nnoremap va<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  30)<cr>
    nnoremap vi<space> :<c-u>call txtObj#Current('scale#space#GetSpaces',  31)<cr>
    onoremap s :<c-u>call txtObj#Current('scale#subword#GetSubWords',  28)<cr>
    nnoremap vs :<c-u>call txtObj#Current('scale#subword#GetSubWords',  30)<cr>
    onoremap w :<c-u>call txtObj#Current('scale#word#GetWords',  28)<cr>
    nnoremap vw :<c-u>call txtObj#Current('scale#word#GetWords',  30)<cr>

    if !exists('g:TextObj_setRepeat')
        nnoremap ; :<c-u>call txtObj#Repeat('n')<cr>
        vnoremap ; :<c-u>call txtObj#Repeat('v')<cr>
    endif
endif