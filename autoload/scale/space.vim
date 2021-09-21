" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
function! scale#space#GetSpaces(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let [tvl, tvc, tcl, tcc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    call util#MakeSelection(a:cursorPos)
    let [tvl, tvc, tcl, tcc] = scale#space#GetSpace(a:scaleMode) 
    if tvl == 0 || tcl == 0
        return [0, 0, 0, 0]
    endif
    let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
    if a:scaleMode == 2
        let validSelection = (selectionForward && (tcl > cl || (tcl == cl && tcc > cc))) || (!selectionForward && (tvl > vl || (tvl == vl && tvc > vc)))
        if validSelection
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
        let validSelection = (selectionForward && (tcl < ocl || (tcl == ocl && tcc < occ))) || (!selectionForward && (tvl < ovl || (tvl == ovl && tvc < ovc)))
        if validSelection
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

function! scale#space#GetSpace(scaleMode)
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    let [pattern1, pattern2] = ["", ""]
    if a:scaleMode == 1 || a:scaleMode == -1
        if selectionForward
            let pattern1 = g:spacePatterns.last
            let pattern2 = g:spacePatterns.first
        else
            let pattern1 = g:spacePatterns.first
            let pattern2 = g:spacePatterns.last
        endif
    elseif a:scaleMode == 2 || a:scaleMode == -2
        if selectionForward
            let pattern1 = g:spacePatterns.first
            let pattern2 = g:spacePatterns.last
        else
            let pattern1 = g:spacePatterns.last
            let pattern2 = g:spacePatterns.first
        endif
    endif
    let [cl, cc] = searchpos(pattern1, 'W')
    call cursor(vl, vc)
    let [vl, vc] = searchpos(pattern2, 'bW')
    return [vl, vc, cl ,cc]
endfunction