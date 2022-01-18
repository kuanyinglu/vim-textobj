"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#word#GetWords(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    let [cl, cc] = a:cursorPos
    let pattern = g:TextObj_wordPatterns
    call cursor(cl, cc)
    let [trl, trc] = move#word#GetWord(pattern, a:seekDir)
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

function! move#word#GetWord(wordPatterns, seekDir)
    let [_, l, c, _, _] = getcurpos()
    let [rl, rc] = [l, c]
    if a:seekDir >= 1
        if a:seekDir == 1
            let [_, _, rl, rc] = move#word#GetWordForward(a:wordPatterns.opening, a:wordPatterns.closing)
        else
            let [rl, rc, _, _] = move#word#GetWordForward(a:wordPatterns.opening, a:wordPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir <= -1
        if a:seekDir == -1
            let [_, _, rl, rc] = move#word#GetWordBackward(a:wordPatterns.opening, a:wordPatterns.closing)
        else
            let [rl, rc, _, _] = move#word#GetWordBackward(a:wordPatterns.opening, a:wordPatterns.closing)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
endfunction

function! move#word#GetWordForward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:openPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:closePattern, 'Wn') 
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction

function! move#word#GetWordBackward(openPattern, closePattern)
    let [tl1, tc1] = searchpos(a:closePattern, 'bWn')
    let [tl2, tc2] = searchpos(a:openPattern, 'bWn')
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction