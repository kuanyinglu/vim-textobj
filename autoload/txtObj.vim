function! GetSeekDir(mode)
    if a:mode == 0
        return 1
    elseif a:mode == 1
        return -1
    elseif a:mode == 2
        return 1
    elseif a:mode == 3
        return -1
    endif
endfunction

function! SetupCursor(mode)
    if a:mode == 0
    elseif a:mode == 1
    elseif a:mode == 2
        normal! gv
    elseif a:mode == 3
        normal! gv
    endif
endfunction

" 0 - normal mode, forward
" 1 - normal mode, backward
" 2 - visual mode, forward
" 3 - visual mode, backward
" 4 - visual mode, trim
" 5 - visual mode, expand
" 6 - op mode, forward
" 7 - op mode, backward
" 8 - op mode, current
function! txtObj#Move(f, mode)
    let multiplier = v:count1
    let seekDir = GetSeekDir(a:mode)
    call SetupCursor(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    if a:mode == 0
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 1
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 2
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 3
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir, multiplier])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    endif
endfunction