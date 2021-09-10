"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
"           3 - forward, end, inner
"           -3 - backward, start, inner
"           4 - forward, start, inner
"           -4 backward, start, inner
function! move#tag#GetTags(cursorPos, seekDir, multiplier)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    let pattern = {}
    if a:seekDir == 1 || a:seekDir == -2
        let pattern.closing = g:tagPatterns.ee
    else
        let pattern.closing = g:tagPatterns.se
    endif
    if a:seekDir == -1 || a:seekDir == 2
        let pattern.opening = g:tagPatterns.ss
    else
        let pattern.opening = g:tagPatterns.es
    endif
    call cursor(cl, cc)
    let [trl, trc] = move#pair#GetPair(pattern, a:seekDir, a:multiplier)
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
    else
    endif
    return [rl, rc]
endfunction