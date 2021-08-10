let g:quotePatterns = ["'", '\(\\\)\@<!"', '`']
let g:blockPatterns = [{ 'opening': '{', 'closing': '}' }, { 'opening': '[', 'closing': ']' }, { 'opening': '<', 'closing': '>' }, { 'opening': '(', 'closing': ')' }]

" 0 - normal mode, forward
" 1 - normal mode, backward
" 2 - visual mode, forward
" 3 - visual mode, backward
" 4 - visual mode, trim
" 5 - visual mode, expand
" 6 - op mode, forward
" 7 - op mode, backward
" 8 - op mode, current
" map # :<c-u>call GetPair('', { 'opening': '{', 'closing': '}'}, 1)<cr>
nmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  0)<cr>
nmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  1)<cr>
vmap ]q :<c-u>call txtObj#Move('move#quote#GetQuotes',  2)<cr>
vmap [q :<c-u>call txtObj#Move('move#quote#GetQuotes',  3)<cr>
nmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  0)<cr>
nmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  1)<cr>
vmap ]b :<c-u>call txtObj#Move('move#pair#GetPairs',  2)<cr>
vmap [b :<c-u>call txtObj#Move('move#pair#GetPairs',  3)<cr>