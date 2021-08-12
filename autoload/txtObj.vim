function! GetSeekDir(mode)
    if a:mode == 0
        return 1
    elseif a:mode == 1
        return -1
    elseif a:mode == 2
        return 2
    elseif a:mode == 3
        return -2
    elseif a:mode == 4
        return 1
    elseif a:mode == 5
        return -1
    elseif a:mode == 6
        return 2
    elseif a:mode == 7
        return -2
    endif
endfunction

function! SetupCursor(mode)
    if a:mode == 0
    elseif a:mode == 1
    elseif a:mode == 2
    elseif a:mode == 3
    elseif a:mode == 4
        normal! gv
    elseif a:mode == 5
        normal! gv
    elseif a:mode == 6
        normal! gv
    elseif a:mode == 7
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
" 8 - visual mode, trim
" 9 - visual mode, expand
" 10 - op mode, forward
" 11 - op mode, backward
" 12 - op mode, current
function! txtObj#Move(f, mode)
    let multiplier = v:count1
    let seekDir = GetSeekDir(a:mode)
    call SetupCursor(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    if a:mode == 0 || a:mode == 2
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 1 || a:mode == 3
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 4 || a:mode == 6
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 5 || a:mode == 7
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    endif
endfunction