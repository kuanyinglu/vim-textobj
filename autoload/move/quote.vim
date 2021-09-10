"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, start, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#quote#GetQuotes(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:quotePatterns
        call cursor(cl, cc)
        let [trl, trc] = move#quote#GetOneQuote(pattern, a:seekDir)
        if a:seekDir >= 1 || a:seekDir <= 4
            if trl != 0 && trc != 0 && (trl < rl || (trl == rl && trc < rc) || rl == 0)
                let [rl, rc] = [trl, trc]
                if a:seekDir == 3
                    let [rl, rc] = util#GetPrevPos(rl, rc)
                elseif a:seekDir == 4
                    let [rl, rc] = util#GetNextPos(rl, rc)
                endif
            endif
        elseif a:seekDir <= -1 || a:seekDir >= -4
            if trl != 0 && trc != 0 && (trl > rl || (trl == rl && trc > rc) || rl == 0)
                let [rl, rc] = [trl, trc]
                if a:seekDir == -3
                    let [rl, rc] = util#GetNextPos(rl, rc)
                elseif a:seekDir == -4
                    let [rl, rc] = util#GetPrevPos(rl, rc)
                endif
            endif
        endif
    endfor
    return [rl, rc]
endfunction

function! move#quote#GetOneQuote(quotePattern, seekDir)
    let [_, l, c, _, _] = getcurpos()
    if (a:seekDir == 3 || a:seekDir == 4) && util#MatchNextChar(a:quotePattern, l, c)
        let [l, c] = util#GetNextPos(l, c)
        call cursor(l, c)
    endif
    if (a:seekDir == -3 || a:seekDir == -4) && util#MatchPrevChar(a:quotePattern, l, c)
        let [l, c] = util#GetPrevPos(l, c)
        call cursor(l, c)
    endif
    let [rl, rc] = [l, c]
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
    let leftC = len(split(left, a:quotePattern, 1)) - 1
    let cc = len(split(cursor, a:quotePattern, 1)) - 1
    let cc2 = len(split(cursor2, a:quotePattern, 1)) - 1
    let rightC = len(split(right, a:quotePattern, 1)) - 1

    let cursorOnQuote = cc == 1 && cc2 > 0 
    " assume current line is inside quote if no quote is in the line at all
    let quotingLeft = (leftC % 2 == 1) || (leftC == 0 && rightC == 0 && !cursorOnQuote)
    let quotingRight = (rightC % 2 == 1) || (leftC == 0 && rightC == 0)
    if a:seekDir >= 1 && a:seekDir <= 4
        if ((!quotingRight && (a:seekDir == 1 || a:seekDir == 3))) || (quotingRight && (a:seekDir == 2 || a:seekDir == 4))
            call searchpos(a:quotePattern, 'W')
        endif
        let [rl, rc] = searchpos(a:quotePattern,  'W')
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1 && a:seekDir >= -4
        if ((!quotingLeft && (a:seekDir == -1 || a:seekDir == -3))) || (quotingLeft && (a:seekDir == -2 || a:seekDir == -4))
            call searchpos(a:quotePattern, 'bW')
        endif
        let [rl, rc] = searchpos(a:quotePattern,  'bW')
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
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