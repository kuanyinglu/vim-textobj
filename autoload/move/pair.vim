"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, end, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#pair#GetPairs(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:TextObj_blockPatterns
        call cursor(cl, cc)
        let [trl, trc] = move#pair#GetPair(pattern, a:seekDir)
        if a:seekDir == 1 || a:seekDir == 2 || a:seekDir == 3 || a:seekDir == 4
            if trl != 0 && trc != 0 && (trl < rl || (trl == rl && trc < rc) || rl == 0)
                let [rl, rc] = [trl, trc]
                if a:seekDir == 3
                    let [rl, rc] = util#GetPrevPos(rl, rc)
                elseif a:seekDir == 4
                    let [rl, rc] = util#GetNextPos(rl, rc)
                endif
            endif
        elseif a:seekDir == -1 || a:seekDir == -2 || a:seekDir == -3 || a:seekDir == -4
            if trl != 0 && trc != 0 && (trl > rl || (trl == rl && trc > rc) || rl == 0)
                let [rl, rc] = [trl, trc]
                if a:seekDir == -3
                    let [rl, rc] = util#GetNextPos(rl, rc)
                elseif a:seekDir == -4
                    let [rl, rc] = util#GetPrevPos(rl, rc)
                endif
            endif
        else
        endif
    endfor
    return [rl, rc]
endfunction

function! move#pair#GetPair(pairPatterns, seekDir)
    let [_, l, c, _, _] = getcurpos()
    let [rl, rc] = [l, c]
    if a:seekDir >= 1 && a:seekDir <= 4
        if (a:seekDir == 3) && util#MatchNextChar(a:pairPatterns.closing, l, c)
            let [l, c] = util#GetNextPos(l, c)
            call cursor(l, c)
        endif
        if (a:seekDir == 4) && util#MatchPrevChar(a:pairPatterns.opening, l, c)
            let [l, c] = util#GetPrevPos(l, c)
            call cursor(l, c)
        endif
        if a:seekDir == 1 || a:seekDir == 3
            let [_, _, rl, rc] = move#pair#GetPairForward(a:pairPatterns.opening, a:pairPatterns.closing)
        else
            let [rl, rc, _, _] = move#pair#GetPairForward(a:pairPatterns.opening, a:pairPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1 && a:seekDir >= -4
        if (a:seekDir == -4) && util#MatchNextChar(a:pairPatterns.closing, l, c)
            let [l, c] = util#GetNextPos(l, c)
            call cursor(l, c)
        endif
        if (a:seekDir == -3) && util#MatchPrevChar(a:pairPatterns.opening, l, c)
            let [l, c] = util#GetPrevPos(l, c)
            call cursor(l, c)
        endif
        if a:seekDir == -1 || a:seekDir == -3
            let [_, _, rl, rc] = move#pair#GetPairBackward(a:pairPatterns.opening, a:pairPatterns.closing)
        else
            let [rl, rc, _, _] = move#pair#GetPairBackward(a:pairPatterns.opening, a:pairPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
endfunction

function! move#pair#GetPairForward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:openPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:closePattern, 'Wn') 
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction

function! move#pair#GetPairBackward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:closePattern, 'bWn')
    let [tl2, tc2] = searchpos(a:openPattern, 'bWn')
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction