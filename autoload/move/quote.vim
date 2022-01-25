"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, end, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#quote#GetQuotes(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:TextObj_quotePatterns
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
    let line = getline('.')
    let col = col('.')
    let [quotingLeft, quotingRight] = util#GetQuoteDir(line, col, a:quotePattern)
    let [rl, rc] = [l, c]
    
    if a:seekDir >= 1 && a:seekDir <= 4
        if (a:seekDir == 3) && util#MatchNextChar(a:quotePattern, l, c)
            let [l, c] = util#GetNextPos(l, c)
            call cursor(l, c)
        endif
        if (a:seekDir == 4) && util#MatchPrevChar(a:quotePattern, l, c)
            let [l, c] = util#GetPrevPos(l, c)
            call cursor(l, c)
        endif
        if ((!quotingRight && (a:seekDir == 1 || a:seekDir == 3))) || (quotingRight && (a:seekDir == 2 || a:seekDir == 4))
            call searchpos(a:quotePattern, 'W')
        endif
        let [rl, rc] = searchpos(a:quotePattern,  'W')
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1 && a:seekDir >= -4
        if (a:seekDir == -4) && util#MatchNextChar(a:quotePattern, l, c)
            let [l, c] = util#GetNextPos(l, c)
            call cursor(l, c)
        endif
        if (a:seekDir == -3) && util#MatchPrevChar(a:quotePattern, l, c)
            let [l, c] = util#GetPrevPos(l, c)
            call cursor(l, c)
        endif
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