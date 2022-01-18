" scaleMode 1 - expand, end
"           -1 - shrink, end
"           3 - current
function! scale#subword#GetSubWords(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    call util#MakeSelection(a:cursorPos)
    let [tvl, tvc, tcl, tcc] = scale#subword#GetSubWord(g:subwordPatterns, a:scaleMode)
    if tvl == 0 || tcl == 0
        return [0, 0, 0, 0]
    endif
    if a:scaleMode == 1
        let validSelection = (selectionForward && (tcl > cl || (tcl == cl && tcc > cc))) || (!selectionForward && (tvl > vl || (tvl == vl && tvc > vc)))
        if validSelection
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    elseif a:scaleMode == -1
        let validSelection = (selectionForward && (tcl < cl || (tcl == cl && tcc < cc))) || (!selectionForward && (tvl < vl || (tvl == vl && tvc < vc)))
        if validSelection
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    elseif a:scaleMode == 3
        let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#subword#GetSubWord(subwordPattens, scaleMode)
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if a:scaleMode == 1
        let [vl, vc, cl ,cc] = scale#subword#GetSubWordOutward([vl, vc, cl, cc], a:subwordPattens.opening, a:subwordPattens.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == -1
        let [vl, vc, cl ,cc] = scale#subword#GetSubWordInward([vl, vc, cl, cc], a:subwordPattens.opening, a:subwordPattens.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == 3
        let [vl, vc, cl ,cc] = scale#subword#GetSubWordCurrent([cl, cc], a:subwordPattens.opening, a:subwordPattens.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#subword#GetSubWordOutward(cursorPos, openPattern, closePattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [cl, cc] = searchpos(a:closePattern, 'W')
        call cursor(vl, vc)
        let [vl, vc] = searchpos(a:openPattern, 'bW')
    else
        let [cl, cc] = searchpos(a:openPattern, 'bW')
        call cursor(vl, vc)
        let [vl, vc] = searchpos(a:closePattern, 'W')
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#subword#GetSubWordInward(cursorPos, openPattern, closePattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let [tvl, tvc, tcl, tcc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [tcl, tcc] = searchpos(a:openPattern, 'bW')
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:closePattern, 'W')
        if tvl != 0 && tcl != 0 && tcl >= tvl && tcc >= tvc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    else
        let [tcl, tcc] = searchpos(a:closePattern, 'W')
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:openPattern, 'bW')
        if tvl != 0 && tcl != 0 && tvl >= tcl && tvc >= tcc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    endif
    return [tvl, tvc, tcl, tcc]
endfunction

function! scale#subword#GetSubWordCurrent(cursorPos, openPattern, closePattern)
    let [cl, cc] = a:cursorPos
    let [vl, vc] = [cl, cc]
    let [tcl, tcc] = searchpos(a:closePattern, 'cWn')
    let [tvl, tvc] = searchpos(a:openPattern, 'bcWn')
    let cursorOnClose = tcl == cl && tcc == cc
    let cursorOnOpen = tvl == vl && tvc == vc
    if !cursorOnClose
        let [cl, cc] = searchpos(a:closePattern, 'W')
    endif
    call cursor(vl, vc)
    if !cursorOnOpen
        let [vl, vc] = searchpos(a:openPattern, 'bW')
    endif
    return [vl, vc, cl ,cc]
endfunction
