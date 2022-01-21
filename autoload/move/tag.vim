"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, end, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#tag#GetTags(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    let pattern = {}
    if a:seekDir == 1 || a:seekDir == -2
        let pattern.closing = g:TextObj_tagPatterns.tagClosingInverted
    else
        let pattern.closing = g:TextObj_tagPatterns.tagClosing
    endif
    if a:seekDir == -1 || a:seekDir == 2
        let pattern.opening = g:TextObj_tagPatterns.tagOpening
    else
        let pattern.opening = g:TextObj_tagPatterns.tagOpeningInverted
    endif
    call cursor(cl, cc)
    let [trl, trc] = move#tag#GetTag(pattern, a:seekDir)
    if a:seekDir >= 1 && a:seekDir <= 4
        if trl != 0 && trc != 0 && (trl < rl || (trl == rl && trc < rc) || rl == 0)
            let [rl, rc] = [trl, trc]
            if a:seekDir == 3
                let [rl, rc] = util#GetPrevPos(rl, rc)
            elseif a:seekDir == 4
                let [rl, rc] = util#GetNextPos(rl, rc)
            endif
        endif
    elseif a:seekDir <= -1 && a:seekDir >= -4
        if trl != 0 && trc != 0 && (trl > rl || (trl == rl && trc > rc) || rl == 0)
            let [rl, rc] = [trl, trc]
            if a:seekDir == -3
                let [rl, rc] = util#GetNextPos(rl, rc)
            elseif a:seekDir == -4
                let [rl, rc] = util#GetPrevPos(rl, rc)
            endif
        endif
    endif
    return [rl, rc]
endfunction

function! move#tag#GetTag(patterns, seekDir)
    let [_, l, c, _, _] = getcurpos()
    let [rl, rc] = [l, c]
    if a:seekDir >= 1 && a:seekDir <= 4
        if a:seekDir == 3
            let [tl, tc] = searchpos(a:patterns.closing, 'Wn')
            let [tl, tc] = util#GetPrevPos(tl, tc)
            if tl == l && tc == c
                let [_, _, rl, rc] = move#pair#GetPairForward(a:patterns.opening, a:patterns.closing)
            endif
        elseif a:seekDir == 4
            let [tl, tc] = searchpos(a:patterns.closing, 'Wn')
            let [tl, tc] = util#GetNextPos(tl, tc)
            if tl == l && tc == c
                let [_, _, rl, rc] = move#pair#GetPairForward(a:patterns.opening, a:patterns.closing)
            endif
        endif
        if a:seekDir == 1 || a:seekDir == 3
            let [_, _, rl, rc] = move#pair#GetPairForward(a:patterns.opening, a:patterns.closing)
        else
            let [rl, rc, _, _] = move#pair#GetPairForward(a:patterns.opening, a:patterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1 && a:seekDir >= -4
        if a:seekDir == -3
            let [tl, tc] = searchpos(a:patterns.opening, 'bWn')
            let [tl, tc] = util#GetNextPos(tl, tc)
            if tl == l && tc == c
                let [_, _, rl, rc] = move#pair#GetPairBackward(a:patterns.opening, a:patterns.closing)
            endif
        elseif a:seekDir == -4
            let [tl, tc] = searchpos(a:patterns.opening, 'bWn')
            let [tl, tc] = util#GetPrevPos(tl, tc)
            if tl == l && tc == c
                let [_, _, rl, rc] = move#pair#GetPairBackward(a:patterns.opening, a:patterns.closing)
            endif
        endif
        if a:seekDir == -1 || a:seekDir == -3
            let [_, _, rl, rc] = move#pair#GetPairBackward(a:patterns.opening, a:patterns.closing)
        else
            let [rl, rc, _, _] = move#pair#GetPairBackward(a:patterns.opening, a:patterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
endfunction
