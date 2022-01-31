"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#space#GetSpaces(cursorPos, seekDir)
    let [rl, rc] = [0, 0]
    if a:seekDir == 1
        let [rl, rc] = searchpos(g:TextObj_spacePatterns.last, 'Wn') 
    elseif a:seekDir == 2
        let [rl, rc] = searchpos(g:TextObj_spacePatterns.first, 'Wn') 
    elseif a:seekDir == -1
        let [rl, rc] = searchpos(g:TextObj_spacePatterns.first, 'bWn') 
    elseif a:seekDir == -2
        let [rl, rc] = searchpos(g:TextObj_spacePatterns.last, 'bWn') 
    endif
    return [rl, rc]
endfunction