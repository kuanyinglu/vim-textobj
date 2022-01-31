let s:repeatCommand = ''
let s:repeatCommandInner = ''
let s:repeatCommandMode = 0
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
" 16 - visual mode, expand
" 17 - visual mode, trim
" 18 - visual mode, expand, inner
" 19 - visual mode, trim, inner
" 20 - op mode, forward, end
" 21 - op mode, backward, end
" 22 - op mode, forward, start
" 23 - op mode, backward, start
" 24 - op mode, forward, end, inner
" 25 - op mode, backward, end, inner
" 26 - op mode, forward, start, inner
" 27 - op mode, backward, start, inner
" 28 - op mode, current
" 29 - op mode, current, inner
" 30 - normal mode, current
" 31 - normal mode, current, inner
function! GetSeekDir(mode)
    if a:mode == 0 || a:mode == 4 || a:mode == 20
        return 1
    elseif a:mode == 1 || a:mode == 5 || a:mode == 21
        return -1
    elseif a:mode == 2 || a:mode == 6 || a:mode == 22
        return 2
    elseif a:mode == 3 || a:mode == 7 || a:mode == 23
        return -2
    elseif a:mode == 8 || a:mode == 12 || a:mode == 24
        return 3
    elseif a:mode == 9 || a:mode == 13 || a:mode == 25
        return -3
    elseif a:mode == 10 || a:mode == 14 || a:mode == 26
        return 4
    elseif a:mode == 11 || a:mode == 15 || a:mode == 27
        return -4
    endif
endfunction

function! GetScaleMode(mode)
    if a:mode == 16
        return 1
    elseif a:mode == 17
        return -1
    elseif a:mode == 18
        return 2
    elseif a:mode == 19
        return -2
    elseif a:mode == 28 || a:mode == 30
        return 3
    elseif a:mode == 29 || a:mode == 31
        return 4
    endif
endfunction

function! SetupCursor(mode)
    if (a:mode >= 4 && a:mode <= 7) || (a:mode >= 12 && a:mode <= 15)
        normal! gv
    endif
endfunction

function! txtObj#Move(f, mode)
    let multiplier = v:count1
    let seekDir = GetSeekDir(a:mode)
    call SetupCursor(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    let [rl, rc] = [0, 0]
    call txtObj#SetRepeat('txtObj#Move', a:f, a:mode)
    if a:mode >= 0 && a:mode <= 15
        for _ in range(multiplier)
            let [rl, rc] = call(function(a:f), [[cl, cc], seekDir])
            if rl != 0 && rc != 0
                call cursor(rl, rc)
                let [_, cl, cc, _, _] = getcurpos()
                let [rl, rc] = [0, 0]
            else
                call cursor(cl, cc)
                break
            endif
        endfor
    endif
endfunction

function! txtObj#Op(f, mode)
    let multiplier = v:count1
    let seekDir = GetSeekDir(a:mode)
    call SetupCursor(a:mode)
    let [_, cl, cc, _, _] = getcurpos()
    let [rl, rc] = [0, 0]
    call txtObj#SetRepeat('', a:f, a:mode)
    if a:mode >= 20 && a:mode <= 27
        for _ in range(multiplier)
            let [rl, rc] = call(function(a:f), [[cl, cc], seekDir])
            if rl != 0 && rc != 0
                if a:mode == 20 || a:mode == 22 || a:mode == 24 || a:mode == 26
                    "Needed +1 shift for the end
                    let [rl, rc] = util#GetNextPos(rl, rc)
                endif
                call cursor(rl, rc)
                let [_, cl, cc, _, _] = getcurpos()
                let [rl, rc] = [0, 0]
            else
                call cursor(cl, cc)
                break
            endif
        endfor
    endif
endfunction

function! txtObj#Scale(f, mode)
    let multiplier = v:count1
    let scaleMode = GetScaleMode(a:mode)
    normal! gv
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    call txtObj#SetRepeat('txtObj#Scale', a:f, a:mode)
    if a:mode >= 16 && a:mode <= 19 
        for _ in range(multiplier)
            let [tvl, tvc, tcl ,tcc] = call(function(a:f), [[vl, vc, cl, cc], scaleMode])
            if tvl != 0
                call util#MakeSelection([tvl, tvc, tcl, tcc])
                let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
            else
                call util#MakeSelection([vl, vc, cl, cc])
                break
            endif
        endfor
    endif
endfunction

function! txtObj#Current(f, mode)
    let [cl, cc] = [line('.'), col('.')]
    let scaleMode = GetScaleMode(a:mode)
    normal! v
    call txtObj#SetRepeat('txtObj#Current', a:f, a:mode)
    let [tvl, tvc, tcl ,tcc] = call(function(a:f), [[cl, cc, cl, cc], scaleMode])
    if tvl != 0
        call util#MakeSelection([tvl, tvc, tcl, tcc])
    else
        call cursor(cl, cc)
    endif
endfunction

function! txtObj#Repeat(callingMode)
    let newMode = txtObj#ConvertMode(a:callingMode, s:repeatCommandMode)
    if len(s:repeatCommand) > 0 && len(s:repeatCommandInner) > 0 && newMode != -1
        call call(function(s:repeatCommand), [s:repeatCommandInner, newMode])
    endif
endfunction

function! txtObj#SetRepeat(f, innerF, mode)
    let s:repeatCommand = a:f
    let s:repeatCommandInner = a:innerF
    let s:repeatCommandMode = a:mode
endfunction

" Convert to use the right function depending on whether its visual mode or normal mode
function! txtObj#ConvertMode(callingMode, originalMode)
    if a:callingMode == 'v'
        if a:originalMode >= 0 && a:originalMode <= 3
            return a:originalMode + 4
        elseif a:originalMode >= 4 && a:originalMode <= 7
            return a:originalMode
        elseif a:originalMode >= 8 && a:originalMode <= 11
            return a:originalMode + 4
        elseif a:originalMode >= 12 && a:originalMode <= 19
            return a:originalMode
        else
            return -1
        endif
    elseif a:callingMode == 'n'
        if a:originalMode >= 0 && a:originalMode <= 3
            return a:originalMode
        elseif a:originalMode >= 4 && a:originalMode <= 7
            return a:originalMode - 4
        elseif a:originalMode >= 8 && a:originalMode <= 11
            return a:originalMode
        elseif a:originalMode >= 12 && a:originalMode <= 15
            return a:originalMode - 4
        elseif a:originalMode >= 30 && a:originalMode <= 31
            return a:originalMode
        else
            return -1
        endif
    else
        return -1
    endif
endfunction