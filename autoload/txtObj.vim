function! GetSeekDir(mode)
    if a:mode == 0 || a:mode == 4
        return 1
    elseif a:mode == 1 || a:mode == 5
        return -1
    elseif a:mode == 2 || a:mode == 6
        return 2
    elseif a:mode == 3 || a:mode == 7
        return -2
    elseif a:mode == 8 || a:mode == 12
        return 3
    elseif a:mode == 9 || a:mode == 13
        return -3
    elseif a:mode == 10 || a:mode == 14
        return 4
    elseif a:mode == 11 || a:mode == 15
        return -4
    endif
endfunction

function! SetupCursor(mode)
    if (a:mode >= 4 && a:mode <= 7) || (a:mode >= 12 && a:mode <= 15)
        normal! gv
    endif
endfunction

" 0 - normal mode, forward, end
" 1 - normal mode, backward, end
" 2 - normal mode, forward, start
" 3 - normal mode, backward, start
" 4 - visual mode, forward, end
" 5 - visual mode, backward, end
" 6 - visual mode, forward, start
" 7 - visual mode, backward, start
" 8 - normal mode, forward, end, inner
" 9 - normal mode, backward, end, inner
" 10 - normal mode, forward, start, inner
" 11 - normal mode, backward, start, inner
" 12 - visual mode, forward, end, inner
" 13 - visual mode, backward, end, inner
" 14 - visual mode, forward, start, inner
" 15 - visual mode, backward, start, inner
" 16 - visual mode, trim
" 17 - visual mode, expand
" 18 - op mode, forward
" 19 - op mode, backward
" 20 - op mode, current
function! txtObj#Move(f, mode)
    let multiplier = v:count1
    let seekDir = GetSeekDir(a:mode)
    call SetupCursor(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    if a:mode == 0 || a:mode == 2 || a:mode == 8 || a:mode == 10
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 1 || a:mode == 3 || a:mode == 9 || a:mode == 11
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 4 || a:mode == 6 || a:mode == 12 || a:mode == 14
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 5 || a:mode == 7 || a:mode == 13 || a:mode == 15
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    endif
endfunction