" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
"           3 - current
"           4 - current, inner
function! scale#space#GetSpaces(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let [tvl, tvc, tcl, tcc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    call util#MakeSelection(a:cursorPos)
    let [tvl, tvc, tcl, tcc] = scale#space#GetSpace(a:scaleMode) 
    if tvl == 0 || tcl == 0
        return [0, 0, 0, 0]
    endif
    if a:scaleMode == 1 || a:scaleMode == 2
        let validSelection = (selectionForward && (tcl > cl || (tcl == cl && tcc > cc))) || (!selectionForward && (tvl > vl || (tvl == vl && tvc > vc)))
        if validSelection
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
            if a:scaleMode == 2
                if selectionForward
                    let [cl, cc] = util#GetPrevPos(cl, cc)
                    let [vl, vc] = util#GetNextPos(vl, vc)
                else
                    let [cl, cc] = util#GetNextPos(cl, cc)
                    let [vl, vc] = util#GetPrevPos(vl, vc)
                endif
            endif
        endif
    elseif a:scaleMode == -1 || a:scaleMode == -2
        let validSelection = (selectionForward && (tcl < cl || (tcl == cl && tcc < cc))) || (!selectionForward && (tvl < vl || (tvl == vl && tvc < vc)))
        if validSelection
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
            if a:scaleMode == -2
                if selectionForward
                    let [cl, cc] = util#GetPrevPos(cl, cc)
                    let [vl, vc] = util#GetNextPos(vl, vc)
                else
                    let [cl, cc] = util#GetNextPos(cl, cc)
                    let [vl, vc] = util#GetPrevPos(vl, vc)
                endif
            endif
        endif
    elseif a:scaleMode == 3 || a:scaleMode == 4
        let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        if a:scaleMode == 4
            let [cl, cc] = util#GetPrevPos(cl, cc)
            let [vl, vc] = util#GetNextPos(vl, vc)
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#space#GetSpace(scaleMode)
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    let [pattern1, pattern2] = ["", ""]
    if a:scaleMode == 1 || a:scaleMode == -1 || a:scaleMode == 3
        if selectionForward
            let pattern1 = g:TextObj_spacePatterns.last
            let pattern2 = g:TextObj_spacePatterns.first
        else
            let pattern1 = g:TextObj_spacePatterns.first
            let pattern2 = g:TextObj_spacePatterns.last
        endif
    elseif a:scaleMode == 2 || a:scaleMode == -2 || a:scaleMode == 4
        if selectionForward
            let pattern1 = g:TextObj_spacePatterns.first
            let pattern2 = g:TextObj_spacePatterns.last
        else
            let pattern1 = g:TextObj_spacePatterns.last
            let pattern2 = g:TextObj_spacePatterns.first
        endif
    endif
    if a:scaleMode == 2 || a:scaleMode == -2
        if selectionForward
            let [cl, cc] = util#GetNextPos(cl, cc)
            let [vl, vc] = util#GetPrevPos(vl, vc)
        else
            let [cl, cc] = util#GetPrevPos(cl, cc)
            let [vl, vc] = util#GetNextPos(vl, vc)
        endif
    endif
    if a:scaleMode == 1 || a:scaleMode == 2
        call cursor(cl, cc)
        if selectionForward
            let [cl, cc] = searchpos(pattern1, 'W')
        else
            let [cl, cc] = searchpos(pattern1, 'bW')
        endif
        call cursor(vl, vc)
        if selectionForward
            let [vl, vc] = searchpos(pattern2, 'bW')
        else
            let [vl, vc] = searchpos(pattern2, 'W')
        endif
    elseif a:scaleMode == -1 || a:scaleMode == -2
        call cursor(cl, cc)
        if selectionForward
            let [cl, cc] = searchpos(pattern1, 'bW')
        else
            let [cl, cc] = searchpos(pattern1, 'W')
        endif
        call cursor(vl, vc)
        if selectionForward
            let [vl, vc] = searchpos(pattern2, 'W')
        else
            let [vl, vc] = searchpos(pattern2, 'bW')
        endif
    elseif a:scaleMode == 3 || a:scaleMode == 4
        let [tcl, tcc] = searchpos(pattern1, 'cWn', cl + 1)
        let [tvl, tvc] = searchpos(pattern2, 'bcWn', vl - 1)
        let cursorOnClose = tcl == cl && tcc == cc
        let cursorOnOpen = tvl == vl && tvc == vc
        if !cursorOnClose
            let [cl, cc] = searchpos(pattern1, 'W')
        endif
        call cursor(vl, vc)
        if !cursorOnOpen
            let [vl, vc] = searchpos(pattern2, 'bW')
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction