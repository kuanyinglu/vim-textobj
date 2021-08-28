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
    let [sl, sc, el, ec] = [0, 0, 0, 0]
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
    let [tsl, tsc, tel, tec] = move#pair#GetPair(pattern, a:seekDir, a:multiplier)
    if a:seekDir == 1 || a:seekDir == 2 || a:seekDir == 3 || a:seekDir == 4
        if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec) || el == 0)
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            if a:seekDir == 3
                let [el, ec] = util#GetPrevPos(el, ec)
            elseif a:seekDir == 4
                let [el, ec] = util#GetNextPos(el, ec)
            endif
        endif
    elseif a:seekDir == -1 || a:seekDir == -2 || a:seekDir == -3 || a:seekDir == -4
        if tsl != 0 && tsc != 0 && (tsl > sl || (tsl == sl && tsc > sc) || sl == 0)
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            if a:seekDir == -3
                let [sl, sc] = util#GetNextPos(sl, sc)
            elseif a:seekDir == -4
                let [sl, sc] = util#GetPrevPos(sl, sc)
            endif
        endif
    else
    endif
    return [sl, sc, el, ec]
endfunction