function! move#quote#GetQuotes(cursorPos, seekDir, multiplier)
    let [sl, sc, el, ec] = [0, 0, 0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:quotePatterns
        call cursor(cl, cc)
        let [tsl, tsc, tel, tec] = GetOneQuote(pattern, a:seekDir, a:multiplier)
        if sl == 0 && sc == 0 && el == 0 && ec == 0
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            continue
        endif
        if a:seekDir == 1
            if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec))
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        elseif a:seekDir == -1
            if tsl != 0 && tsc != 0 && (tsl > sl || (tsl == sl && tsc > sc))
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        else
        endif
    endfor
    return [sl, sc, el, ec]
endfunction

function! GetOneQuote(quotePattern, seekDir, multiplier)
    let [_, l, c, _, _] = getcurpos()
    let [sl, sc, el, ec] = [l, c, l ,c]
    let line = getline('.')
    let col = col('.')

    " cut line in left of, on and right of cursor
    let left = col > 1 ? line[: col-2] : ""
    let cursor = line[col-1]
    " also test for escaped quotes
    let cursor2 = col > 1 ? line[col-2 : col-1] : line[col-1]
    let right = line[col :]

    " how many delitimers left, on and right of cursor
    " assuming current line starts with no quote
    let lc = len(split(left, a:quotePattern, 1)) - 1
    let cc = len(split(cursor, a:quotePattern, 1)) - 1
    let cc2 = len(split(cursor2, a:quotePattern, 1)) - 1
    let rc = len(split(right, a:quotePattern, 1)) - 1

    let cursorOnQuote = cc == 1 && cc2 > 0 
    let quotingLeft = (lc % 2 == 1) || (lc == 0 && rc == 0 && !cursorOnQuote)
    let quotingRight = (rc % 2 == 1) || (lc == 0 && rc == 0)
    if a:seekDir == 1
        let flags = 'W' . (quotingRight ? ('b' . (cursorOnQuote ? 'c' : '')) : '')
        let [sl, sc] = searchpos(a:quotePattern, flags)
        let [el, ec] = searchpos(a:quotePattern,  'W')
        for _ in range(a:multiplier - 1)
            let [tel, tec] = searchpos(a:quotePattern,  'W')
            if tel == 0
                break
            endif
            let [tel, tec] = searchpos(a:quotePattern,  'W')
            if tel == 0
                break
            else
                let [el, ec] = [tel, tec]
            endif
        endfor
    elseif a:seekDir == -1
        let flags = 'W' . (quotingLeft ? ('' . (cursorOnQuote ? 'c' : '')) : 'b')
        let [el, ec] = searchpos(a:quotePattern, flags)
        let [sl, sc] = searchpos(a:quotePattern,  'bW')
        for _ in range(a:multiplier - 1)
            let [tsl, tsc] = searchpos(a:quotePattern,  'bW')
            if tsl == 0
                break
            endif
            let [tsl, tsc] = searchpos(a:quotePattern,  'bW')
            if tsl == 0
                break
            else
                let [sl, sc] = [tsl, tsc]
            endif
        endfor
    else
        if !quotingLeft && !quotingRight
            let [sl, sc, el, ec] = GetQuoteOutward([sl, sc], [sl, sc], a:quotePattern)
        else
            if quotingLeft
                let [sl, sc] = searchpos(a:quotePattern, 'bW')
            endif
            if quotingRight
                let [el, ec] = searchpos(a:quotePattern, 'W')
            endif
        endif
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        endif
        for _ in range(a:multiplier - 1)
            let [tsl, tsc, tel, tec] = GetQuoteOutward([sl, sc], [el, ec], a:quotePattern)
            if tsl == 0 || tel == 0
                return [sl, sc, el, ec]
            else
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
        endfor
    endif
    return [sl, sc, el, ec]
endfunction

function! GetQuoteOutward(curPos1, curPos2, quotePattern)
    let [tl, tc] = a:curPos2
    call cursor(tl, tc)
    call searchpos(a:quotePattern, 'W')
    let [el, ec] = searchpos(a:quotePattern, 'W')
    let [tl, tc] = a:curPos1
    call cursor(tl, tc)
    call searchpos(a:quotePattern, 'bW')
    let [sl, sc] = searchpos(a:quotePattern, 'bW')
    return [sl, sc, el, ec]
endfunction