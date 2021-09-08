function! util#GetNextPos(l, c)
    let [l, c] = [a:l, a:c]
    if a:l != 0
        if a:c == strwidth(getline(l))
            let l = a:l + 1
            let c = 1
        else
            let c = a:c + 1
        endif
    endif
    return [l, c]
endfunction

function! util#MatchNextChar(pattern, l, c)
    let line = getline('.')
    if a:c == strwidth(line)
        let lineNr = line('.')
        let line = getline(lineNr + 1)
        if len(split(line, a:pattern, 1)[0]) == 0 && len(line) > 0
            return v:true
        endif
    else
        let col = col('.')
        let str = line[col]
        let isMatch = len(split(str, a:pattern, 1)) - 1
        if isMatch == 1
            return v:true
        endif
    endif
    return v:false
endfunction

function! util#GetPrevPos(l, c)
    let [l, c] = [a:l, a:c]
    if a:l != 0
        if a:c == 1
            let l = a:l - 1
            let c = strwidth(getline(l))
        else
            let c = a:c - 1
        endif
    endif
    return [l, c]
endfunction

function! util#MatchPrevChar(pattern, l, c)
    let line = getline('.')
    if a:c == 0
        let lineNr = line('.')
        let line = getline(lineNr - 1)
        if len(split(line, a:pattern, 1)[-1]) == 0 && len(line) > 0
            return v:true 
        endif
    else
        let col = col('.')
        let str = line[col-2]
        let isMatch = len(split(str, a:pattern, 1)) - 1
        if isMatch == 1
            return v:true
        endif
    endif
    return v:false
endfunction

function! util#MakeSelection(cursorPos)
    let [vl, vc, cl ,cc] = a:cursorPos
    if mode() == 'v'
        normal! v
    endif
    call cursor(vl, vc)
    normal! v
    call cursor(cl, cc)
endfunction