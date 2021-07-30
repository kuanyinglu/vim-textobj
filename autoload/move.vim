function! GetSeekDir(mode)
    if a:mode == 0
        return 1
    elseif a:mode == 1
        return -1
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
function! Move(f, mode)
    let seekDir = GetSeekDir(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    if a:mode == 0
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir])
        if el != 0 && ec != 0
            call cursor(el, ec)
        else
            call cursor(cl, cc)
        endif
    elseif a:mode == 1
        let [sl, sc, el, ec] = call(function(a:f), [[cl, cc], seekDir])
        if sl != 0 && sc != 0
            call cursor(sl, sc)
        else
            call cursor(cl, cc)
        endif
    endif
endfunction