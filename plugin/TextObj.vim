let g:quotePatterns = ["'", '"', '`']

" map # :<c-u>call GetPair('', { 'opening': '{', 'closing': '}'}, 1)<cr>
nmap ]q :<c-u>call Move('GetQuotes',  0)<cr>
nmap [q :<c-u>call Move('GetQuotes',  1)<cr>