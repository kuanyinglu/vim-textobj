"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#space#GetSpaces(cursorPos, seekDir, multiplier)
    let [sl, sc, el, ec] = [0, 0, 0, 0]
    let [cl, cc] = a:cursorPos
    let multiplier = a:multiplier
    if a:seekDir == 1 || a:seekDir == 2
        let [sl, sc, el, ec] = move#space#GetSpaceForward([sl, sc, el, ec], g:spacePatterns.first, g:spacePatterns.last)
        if sl != 0 && el != 0
            if a:seekDir == 2
                let [el, ec] = [sl, sc]
            endif
            for _ in range(multiplier - 1)
                let [tsl, tsc, tel, tec] = move#space#GetSpaceForward([sl, sc, el, ec], g:spacePatterns.first, g:spacePatterns.last)
                if tel == 0
                    break
                else
                    if a:seekDir == 1
                        let [el, ec] = [tel, tec]
                    else
                        let [el, ec] = [tsl, tsc]
                    endif
                endif
            endfor
        else
            " going to the beginning of the bracket needs to be more strict, or not finding a pair won't be picked up
            if a:seekDir == 2
                let [sl, sc, el, ec] = [0, 0, 0, 0]
            endif
        endif
    elseif a:seekDir == -1 || a:seekDir == -2
        let [sl, sc, el, ec] = move#space#GetSpaceBackward([sl, sc, el, ec], g:spacePatterns.first, g:spacePatterns.last)
        if sl != 0 || el != 0
            if a:seekDir == -2
                let [sl, sc] = [el, ec]
            endif
            for _ in range(multiplier - 1)
                let [tsl, tsc, tel, tec] = move#space#GetSpaceBackward([sl, sc, el, ec], g:spacePatterns.first, g:spacePatterns.last)
                if tsl == 0
                    break
                else
                    if a:seekDir == -1
                        let [sl, sc] = [tsl, tsc]
                    else
                        let [sl, sc] = [tel, tec]
                    endif
                endif
            endfor
        else
            if a:seekDir == -2
                let [sl, sc, el, ec] = [0, 0, 0, 0]
            endif
        endif
    endif
    return [sl, sc, el, ec]
endfunction

function! move#space#GetSpaceForward(cursorPos, startPattern, endPattern)
    let [sl, sc, el, ec] = a:cursorPos
    let [tl1, tc1] = searchpos(a:startPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:endPattern, 'Wn') 
    let [sl, sc, el, ec] = [tl1, tc1, tl2, tc2]
    call cursor(tl2, tc2)
    return [sl, sc, el, ec]
endfunction

function! move#space#GetSpaceBackward(cursorPos, startPattern, endPattern)
    let [sl, sc, el, ec] = a:cursorPos
    let [tl1, tc1] = searchpos(a:endPattern, 'bWn')
    let [tl2, tc2] = searchpos(a:startPattern, 'bWn')
    let [sl, sc, el, ec] = [tl2, tc2, tl1, tc1]
    call cursor(tl2, tc2)
    return [sl, sc, el, ec]
endfunction