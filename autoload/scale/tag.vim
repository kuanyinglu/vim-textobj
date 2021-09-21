" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
function! scale#tag#GetTags(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    let pattern = {}
    if a:scaleMode == 1 || a:scaleMode == -1
        let pattern.closing = g:tagPatterns.ee
        let pattern.opening = g:tagPatterns.ss
    endif
    if a:scaleMode == 2 || a:scaleMode == -2
        let pattern.closing = g:tagPatterns.se
        let pattern.opening = g:tagPatterns.es
    endif
    call cursor(cl, cc)
    let [tvl, tvc, tcl, tcc] = scale#pair#GetPair(pattern, a:scaleMode)
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
    endif
    return [vl, vc, cl ,cc]
endfunction