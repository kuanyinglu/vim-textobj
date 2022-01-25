" scaleMode 1 - expand, end
"           -1 - shrink, end
"           3 - current
function! scale#word#GetWords(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    call util#MakeSelection(a:cursorPos)
    let [tvl, tvc, tcl, tcc] = scale#word#GetWord(g:TextObj_wordPatterns, a:scaleMode)
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
        let validSelection = tcl > cl || (tcl == cl && tcc > cc)
        if validSelection
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#word#GetWord(wordPatterns, scaleMode)
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if a:scaleMode == 1
        let [vl, vc, cl ,cc] = scale#word#GetWordOutward([vl, vc, cl, cc], a:wordPatterns.opening, a:wordPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == -1
        let [vl, vc, cl ,cc] = scale#word#GetWordInward([vl, vc, cl, cc], a:wordPatterns.opening, a:wordPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == 3
        let [vl, vc, cl ,cc] = scale#word#GetWordCurrent([cl, cc], a:wordPatterns.opening, a:wordPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#word#GetWordOutward(cursorPos, openPattern, closePattern)
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

function! scale#word#GetWordInward(cursorPos, openPattern, closePattern)
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

function! scale#word#GetWordCurrent(cursorPos, openPattern, closePattern)
    let [cl, cc] = a:cursorPos
    let [vl, vc] = [cl, cc]
    if util#MatchCurrent(g:TextObj_constant_word, cl, cc)
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
    endif
    return [0, 0, 0, 0]
endfunction
