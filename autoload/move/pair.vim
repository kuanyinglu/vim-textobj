function! move#pair#GetPairs(cursorPos, seekDir, multiplier)
    let [sl, sc, el, ec] = [0, 0, 0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:blockPatterns
        call cursor(cl, cc)
        let [tsl, tsc, tel, tec] = GetPair(pattern, a:seekDir, a:multiplier)
        if sl == 0 && sc == 0 && el == 0 && ec == 0
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            continue
        endif
        if a:seekDir == 1
            if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec))
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        elseif a:seekDir == -1
            if tsl != 0 && tsc != 0 && (tsl > sl || (tsl == sl && tsc > sc))
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        else
        endif
    endfor
    return [sl, sc, el, ec]
endfunction

function! GetPair(pairPatterns, seekDir, multiplier)" direction -1 backwards, 0 current, 1 forward
    let multiplier = v:count1
    let [_, l, c, _, _] = getcurpos()
    let [sl, sc, el, ec] = [l, c, l ,c]
    if a:seekDir == 1
        let [tsl, tsc, tel, tec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        else
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
        endif
        for _ in range(a:multiplier - 1)
            let [_, _, tel, tec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
            if tel == 0
                return [sl, sc, el, ec]
            else
                let [el, ec] = [tel, tec]
            endif
        endfor
    elseif a:seekDir == -1 
        let [tsl, tsc, tel, tec] = GetPairBackward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl == 0 || el == 0
            return [sl, sc, el, ec]
        else
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
        endif
        for _ in range(a:multiplier - 1)
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
        for _ in range(a:multiplier - 1)
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
        let [sl, sc, el, ec] = [tl1, tc1, tl2, tc2]
        call cursor(tl2, tc2)
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
        let [sl, sc, el, ec] = [tl2, tc2, tl1, tc1]
        call cursor(tl2, tc2)
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
