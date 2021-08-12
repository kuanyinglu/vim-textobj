"   seekDir 1 - forward, end
"           -1 - backward, end
"           0 - outward
"           2 - forward, start
"           -2 - backward, start
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
        if a:seekDir == 1 || a:seekDir == 2
            if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec))
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        elseif a:seekDir == -1 || a:seekDir == -2
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
    let multiplier = a:multiplier
    let [_, l, c, _, _] = getcurpos()
    let [sl, sc, el, ec] = [l, c, l ,c]
    if a:seekDir == 1 || a:seekDir == 2
        let [sl, sc, el, ec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl != 0 && el != 0
            if a:seekDir == 2
                let [el, ec] = [sl, sc]
            endif
            for _ in range(multiplier - 1)
                let [tsl, tsc, tel, tec] = GetPairForward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
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
        let [sl, sc, el, ec] = GetPairBackward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
        if sl != 0 || el != 0
            if a:seekDir == -2
                let [sl, sc] = [el, ec]
            endif
            for _ in range(multiplier - 1)
                let [tsl, tsc, tel, tec] = GetPairBackward([sl, sc, el, ec], a:pairPatterns.opening, a:pairPatterns.closing)
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
    let [tl1, tc1] = searchpos(a:openPattern, 'Wn') 
    let [tl2, tc2] = searchpos(a:closePattern, 'Wn') 
    let [sl, sc, el, ec] = [tl1, tc1, tl2, tc2]
    call cursor(tl2, tc2)
    return [sl, sc, el, ec]
endfunction

function! GetPairBackward(cursorPos, openPattern, closePattern)
    let [sl, sc, el, ec] = a:cursorPos
    let [tl1, tc1] = searchpos(a:closePattern, 'bWn')
    let [tl2, tc2] = searchpos(a:openPattern, 'bWn')
    let [sl, sc, el, ec] = [tl2, tc2, tl1, tc1]
    call cursor(tl2, tc2)
    return [sl, sc, el, ec]
endfunction

function! GetPairOutward(openPattern, closePattern)
    let getOuterFlag = matchstr(getline('.'), '\%' . col('.') . 'c.') == a:closePattern ? 'c' : ''
    let [sl, sc] = searchpairpos(a:openPattern, '', a:closePattern, getOuterFlag . 'bW')
    "Skipping case if cursor is on an outer bracket, otherwise will just get back to the same position
    let [el, ec] = searchpairpos(a:openPattern, '', a:closePattern, 'W')
    return [sl, sc, el, ec]
endfunction
