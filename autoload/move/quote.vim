"   seekDir 1 - forward, end
"           -1 - backward, end
"           0 - outward
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, start, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#quote#GetQuotes(cursorPos, seekDir, multiplier)
    let [sl, sc, el, ec] = [0, 0, 0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:quotePatterns
        call cursor(cl, cc)
        let [tsl, tsc, tel, tec] = move#quote#GetOneQuote(pattern, a:seekDir, a:multiplier)
        if a:seekDir == 1 || a:seekDir == 2 || a:seekDir == 3 || a:seekDir == 4
            if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec) || el == 0)
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
                if a:seekDir == 3 || a:seekDir == 4
                    let [sl, sc] = util#GetNextPos(sl, sc)
                    let [el, ec] = util#GetPrevPos(el, ec)
                endif
            endif
            continue
        elseif a:seekDir == -1 || a:seekDir == -2 || a:seekDir == -3 || a:seekDir == -4
            if tsl != 0 && tsc != 0 && (tsl > sl || (tsl == sl && tsc > sc) || sl == 0)
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
                if a:seekDir == -3 || a:seekDir == -4
                    let [sl, sc] = util#GetNextPos(sl, sc)
                    let [el, ec] = util#GetPrevPos(el, ec)
                endif
            endif
            continue
        else
        endif
    endfor
    return [sl, sc, el, ec]
endfunction

function! move#quote#GetOneQuote(quotePattern, seekDir, multiplier)
    let multiplier = a:multiplier
    let [_, l, c, _, _] = getcurpos()
    if (a:seekDir == 3 || a:seekDir == 4) && util#MatchNextChar(a:quotePattern, l, c)
        let [l, c] = util#GetNextPos(l, c)
        call cursor(l, c)
    endif
    if (a:seekDir == -3 || a:seekDir == -4) && util#MatchPrevChar(a:quotePattern, l, c)
        let [l, c] = util#GetPrevPos(l, c)
        call cursor(l, c)
    endif
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
    " assume current line is inside quote if no quote is in the line at all
    let quotingLeft = (lc % 2 == 1) || (lc == 0 && rc == 0 && !cursorOnQuote)
    let quotingRight = (rc % 2 == 1) || (lc == 0 && rc == 0)
    if a:seekDir == 1 || a:seekDir == 2 || a:seekDir == 3 || a:seekDir == 4
        let flags = 'W' . (quotingRight ? ('b' . (cursorOnQuote ? 'c' : '')) : '')
        let [sl, sc] = searchpos(a:quotePattern, flags)
        let [el, ec] = searchpos(a:quotePattern,  'W')
        if el != 0
            if a:seekDir == 2
                let [el, ec] = [sl, sc]
                if el <= l && ec <= c
                    let multiplier = multiplier + 1
                endif
            endif
            for _ in range(multiplier - 1)
                let [tel1, tec1] = searchpos(a:quotePattern,  'W')
                let [tel2, tec2] = searchpos(a:quotePattern,  'W')
                if tel2 == 0
                    break
                else
                    if a:seekDir == 1
                        let [el, ec] = [tel2, tec2]
                    else
                        let [el, ec] = [tel1, tec1]
                    endif
                endif
            endfor
        else
            let [sl, sc, el, ec] = [0, 0, 0, 0]
        endif
    elseif a:seekDir == -1 || a:seekDir == -2 || a:seekDir == -3 || a:seekDir == -4
        let flags = 'W' . (quotingLeft ? ('' . (cursorOnQuote ? 'c' : '')) : 'b')
        let [el, ec] = searchpos(a:quotePattern, flags)
        let [sl, sc] = searchpos(a:quotePattern,  'bW')
        if sl != 0
            if a:seekDir == -2
                let [sl, sc] = [el, ec]
                if sl <= l && sc <= c
                    let multiplier = multiplier + 1
                endif
            endif
            for _ in range(multiplier - 1)
                let [tsl1, tsc1] = searchpos(a:quotePattern,  'bW')
                let [tsl2, tsc2] = searchpos(a:quotePattern,  'bW')
                if tsl2 == 0
                    break
                else
                    if a:seekDir == -1
                        let [sl, sc] = [tsl2, tsc2]
                    else
                        let [sl, sc] = [tsl1, tsc1]
                    endif
                endif
            endfor
        else
            let [sl, sc, el, ec] = [0, 0, 0, 0]
        endif
    else
        if !quotingLeft && !quotingRight
            let [sl, sc, el, ec] = move#quote#GetQuoteOutward([sl, sc], [sl, sc], a:quotePattern)
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
        for _ in range(multiplier - 1)
            let [tsl, tsc, tel, tec] = move#quote#GetQuoteOutward([sl, sc], [el, ec], a:quotePattern)
            if tsl == 0 || tel == 0
                return [sl, sc, el, ec]
            else
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
        endfor
    endif
    return [sl, sc, el, ec]
endfunction

function! move#quote#GetQuoteOutward(curPos1, curPos2, quotePattern)
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