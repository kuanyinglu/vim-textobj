"   using pair functionality instead of trying to validate and stuff for tags
"   seekDir 1 - forward, end
"           -1 - backward, end
"           2 - forward, start
"           -2 - backward, start
function! move#tag#GetTags(cursorPos, seekDir, multiplier)
    let [sl, sc, el, ec] = [0, 0, 0, 0]
    let [cl, cc] = a:cursorPos
    for pattern in g:tagPatterns
        call cursor(cl, cc)
        let [tsl, tsc, tel, tec] = move#pair#GetPair(pattern, a:seekDir, a:multiplier)
        if sl == 0 && sc == 0 && el == 0 && ec == 0
            let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            continue
        endif
        if a:seekDir == 1 || a:seekDir == 2
            if tel != 0 && tec != 0 && (tel < el || (tel == el && tec < ec) || el == 0)
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        elseif a:seekDir == -1 || a:seekDir == -2
            if tsl != 0 && tsc != 0 && (tsl > sl || (tsl == sl && tsc > sc) || sl == 0)
                let [sl, sc, el, ec] = [tsl, tsc, tel, tec]
            endif
            continue
        else
        endif
    endfor
    return [sl, sc, el, ec]
endfunction