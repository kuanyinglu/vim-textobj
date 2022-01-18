"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#subword#GetSubWords(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    let pattern = g:TextObj_subwordPatterns
    call cursor(cl, cc)
    let [trl, trc] = move#subword#GetSubWord(pattern, a:seekDir)
    if a:seekDir == 1 || a:seekDir == 2
        if trl != 0 && trc != 0 && (trl < rl || (trl == rl && trc < rc) || rl == 0)
            let [rl, rc] = [trl, trc]
        endif
    elseif a:seekDir == -1 || a:seekDir == -2
        if trl != 0 && trc != 0 && (trl > rl || (trl == rl && trc > rc) || rl == 0)
            let [rl, rc] = [trl, trc]
        endif
    endif
    return [rl, rc]
endfunction

function! move#subword#GetSubWord(subwordPatterns, seekDir)
    let [_, l, c, _, _] = getcurpos()
    let [rl, rc] = [l, c]
    if a:seekDir >= 1
        if a:seekDir == 1
            let [_, _, rl, rc] = move#subword#GetSubWordForward(a:subwordPatterns.opening, a:subwordPatterns.closing)
        else
            let [rl, rc, _, _] = move#subword#GetSubWordForward(a:subwordPatterns.opening, a:subwordPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1
        if a:seekDir == -1
            let [_, _, rl, rc] = move#subword#GetSubWordBackward(a:subwordPatterns.opening, a:subwordPatterns.closing)
        else
            let [rl, rc, _, _] = move#subword#GetSubWordBackward(a:subwordPatterns.opening, a:subwordPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
endfunction

function! move#subword#GetSubWordForward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:openPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:closePattern, 'Wn') 
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction

function! move#subword#GetSubWordBackward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:closePattern, 'bWn')
    let [tl2, tc2] = searchpos(a:openPattern, 'bWn')
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction