let g:quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '[', 'closing': ']' }, { 'opening': '<', 'closing': '>' }, { 'opening': '(', 'closing': ')' }]
let g:tagPatterns = [{ 'opening': '>', 'closing': '<' }, { 'opening': '<', 'closing': '>' }]
"Tag name from opening   <\zs\w\+\ze>
"Tag name from ending    <\/\zs\w\+\ze>

" 0 - normal mode, forward, end
" 1 - normal mode, backward, end
" 2 - normal mode, forward, start
" 3 - normal mode, backward, start
" 4 - visual mode, forward, end
" 5 - visual mode, backward, end
" 6 - visual mode, forward, start
" 7 - visual mode, backward, start
" 8 - visual mode, trim
" 9 - visual mode, expand
" 10 - op mode, forward
" 11 - op mode, backward
" 12 - op mode, current
nmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  0)<cr>
nmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  1)<cr>
nmap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  2)<cr>
nmap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  3)<cr>
vmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  4)<cr>
vmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  5)<cr>
vmap ]Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  6)<cr>
vmap [Q :<c-u>call txtObj#Move('move#quote#GetQuotes',  7)<cr>
nmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  0)<cr>
nmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  1)<cr>
nmap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  2)<cr>
nmap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  3)<cr>
vmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  4)<cr>
vmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  5)<cr>
vmap ]B :<c-u>call txtObj#Move('move#pair#GetPairs',  6)<cr>
vmap [B :<c-u>call txtObj#Move('move#pair#GetPairs',  7)<cr>
nmap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  0)<cr>
nmap [t :<c-u>call txtObj#Move('move#tag#GetTags',  1)<cr>
nmap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  2)<cr>
nmap [T :<c-u>call txtObj#Move('move#tag#GetTags',  3)<cr>
vmap ]t :<c-u>call txtObj#Move('move#tag#GetTags',  4)<cr>
vmap [t :<c-u>call txtObj#Move('move#tag#GetTags',  5)<cr>
vmap ]T :<c-u>call txtObj#Move('move#tag#GetTags',  6)<cr>
vmap [T :<c-u>call txtObj#Move('move#tag#GetTags',  7)<cr>