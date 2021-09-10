"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#space#GetSpaces(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    if a:seekDir == 1 || a:seekDir == 2
        if a:seekDir == 1
            let [_, _, rl, rc] = move#space#GetSpaceForward(g:spacePatterns.first, g:spacePatterns.last)
        else
            let [rl, rc, _, _] = move#space#GetSpaceForward(g:spacePatterns.first, g:spacePatterns.last)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    elseif a:seekDir == -1 || a:seekDir == -2
        if a:seekDir == -1
            let [_, _, rl, rc] = move#space#GetSpaceBackward(g:spacePatterns.first, g:spacePatterns.last)
        else
            let [rl, rc, _, _] = move#space#GetSpaceBackward(g:spacePatterns.first, g:spacePatterns.last)
        endif
        if rl == 0
            let [rl, rc] = [0, 0]
        endif
    endif
    return [rl, rc]
endfunction

function! move#space#GetSpaceForward(startPattern, endPattern)
    let [tl1, tc1] = searchpos(a:startPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:endPattern, 'Wn') 
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction

function! move#space#GetSpaceBackward(startPattern, endPattern)
    let [tl1, tc1] = searchpos(a:endPattern, 'bWn')
    let [tl2, tc2] = searchpos(a:startPattern, 'bWn')
    call cursor(tl2, tc2)
    return [tl1, tc1, tl2, tc2]
endfunction