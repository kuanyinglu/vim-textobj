function! GetPair(pairPatterns, seekDir)" direction -1 backwards, 0 current, 1 forward
    let multiplier = v:count1
    let [_, l, c, _, _] = getcurpos()
    let [sl, sc, el, ec] = [l, c, l ,c]
    if a:seekDir == 1
        let [sl, sc, el, ec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        endif
        for _ in range(multiplier - 1)
            let [_, _, tel, tec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
            if tel == 0
                return [sl, sc, el, ec]
            else
                let [el, ec] = [tel, tec]
            endif
        endfor
    elseif a:seekDir == -1 
        let [sl, sc, el, ec] = GetPairBackward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        endif
        for _ in range(multiplier - 1)
            let [tsl, tsc, _, _] = GetPairBackward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
            if tsl == 0
                return [sl, sc, el, ec]
            else
                let [sl, sc] = [tsl, tsc]
            endif
        endfor
    else
        let [sl, sc, el, ec] = GetPairOutward(a:pairPatterns.opening, a:pairPatterns.closing)
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        endif
        for _ in range(multiplier - 1)
            let [tsl, tsc, tel, tec] = GetPairOutward(a:pairPatterns.opening, a:pairPatterns.closing)
            if tsl == 0 || tel == 0
                return [sl, sc, el, ec]
            else
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
        endfor
    endif
    return [sl, sc, el, ec]
endfunction

function! GetPairForward(cursorPos, openPattern, closePattern)
    let [sl, sc, el, ec] = a:cursorPos
    let [tl1, tc1] = searchpos(a:openPattern, 'cWn') 
    let [tl2, tc2] = searchpos(a:closePattern, 'Wn') 
    if tl2 < tl1 || (tl2 == tl1 && tc2 < tc1)
        let [el, ec] = [tl2, tc2]
        call cursor(tl2, tc2)
    else
        let [sl, sc] = [tl1, tc1]
        call cursor(tl1, tc1)
        let [el, ec] = searchpairpos(a:openPattern, '', a:closePattern, 'W') 
    endif
    return [sl, sc, el, ec]
endfunction

function! GetPairBackward(cursorPos, openPattern, closePattern)
    let [sl, sc, el, ec] = a:cursorPos
    let [tl1, tc1] = searchpos(a:closePattern, 'cbWn')
    let [tl2, tc2] = searchpos(a:openPattern, 'bWn')
    if tl2 > tl1 || (tl2 == tl1 && tc2 > tc1)
        let [sl, sc] = [tl2, tc2]
        call cursor(tl2, tc2)
    else
        let [el, ec] = [tl1, tc1]
        call cursor(tl1, tc1)
        let [sl, sc] = searchpairpos(a:openPattern, '', a:closePattern, 'bW')
    endif
    return [sl, sc, el, ec]
endfunction

function! GetPairOutward(openPattern, closePattern)
    let getOuterFlag = matchstr(getline('.'), '\%' . col('.') . 'c.') == a:closePattern ? 'c' : ''
    let [sl, sc] = searchpairpos(a:openPattern, '', a:closePattern, getOuterFlag . 'bW')
    "Skipping case if cursor is on an outer bracket, otherwise will just get back to the same position
    let [el, ec] = searchpairpos(a:openPattern, '', a:closePattern, 'W')
    return [sl, sc, el, ec]
endfunction
