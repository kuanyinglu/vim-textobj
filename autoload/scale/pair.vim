" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
"           3 - current
"           4 - current, inner
function! scale#pair#GetPairs(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let [ovl, ovc, ocl, occ] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    for pattern in g:blockPatterns
        call util#MakeSelection(a:cursorPos)
        let [tvl, tvc, tcl, tcc] = scale#pair#GetPair(pattern, a:scaleMode)
        if tvl == 0 || tcl == 0
            continue
        endif
        if a:scaleMode == 1 || a:scaleMode == 2
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let validSelection = (selectionForward && (tcl > ocl || (tcl == ocl && tcc > occ))) || (!selectionForward && (tvl > ovl || (tvl == ovl && tvc > ovc)))
            let closerSelection = (selectionForward && (tcl < cl || (tcl == cl && tcc < cc))) || (!selectionForward && (tvl < vl || (tvl == vl && tvc < vc)))
            if (validSelection && firstSelection) || (validSelection && closerSelection)
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
            continue
        elseif a:scaleMode == -1 || a:scaleMode == -2
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let validSelection = (selectionForward && (tcl < ocl || (tcl == ocl && tcc < occ))) || (!selectionForward && (tvl < ovl || (tvl == ovl && tvc < ovc)))
            let closerSelection = (selectionForward && (tcl > cl || (tcl == cl && tcc > cc))) || (!selectionForward && (tvl > vl || (tvl == vl && tvc > vc)))
            if (validSelection && firstSelection) || (validSelection && closerSelection)
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
            continue
        elseif a:scaleMode == 3 || a:scaleMode == 4
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let closerSelection = (selectionForward && (tcl < cl || (tcl == cl && tcc < cc))) || (!selectionForward && (tvl < vl || (tvl == vl && tvc < vc)))
            if firstSelection || closerSelection
                let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
                if a:scaleMode == 4
                    let [cl, cc] = util#GetPrevPos(cl, cc)
                    let [vl, vc] = util#GetNextPos(vl, vc)
                endif
            endif
        endif
    endfor
    return [vl, vc, cl ,cc]
endfunction

function! scale#pair#GetPair(pairPatterns, scaleMode)
    let [vl, vc, cl ,cc] = [line('v'), col('v'), line('.'), col('.')]
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if a:scaleMode == 1 || a:scaleMode == 2
        if a:scaleMode == 2
            if selectionForward
                let [cl, cc] = util#GetNextPos(cl, cc)
                let [vl, vc] = util#GetPrevPos(vl, vc)
            else
                let [cl, cc] = util#GetPrevPos(cl, cc)
                let [vl, vc] = util#GetNextPos(vl, vc)
            endif
        endif
        let [vl, vc, cl ,cc] = scale#pair#GetPairOutward([vl, vc, cl, cc], a:pairPatterns.opening, a:pairPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == -1 || a:scaleMode == -2
        if a:scaleMode == -2
            if selectionForward
                let [cl, cc] = util#GetPrevPos(cl, cc)
                let [vl, vc] = util#GetNextPos(vl, vc)
            else
                let [cl, cc] = util#GetNextPos(cl, cc)
                let [vl, vc] = util#GetPrevPos(vl, vc)
            endif
        endif
        let [vl, vc, cl ,cc] = scale#pair#GetPairInward([vl, vc, cl, cc], a:pairPatterns.opening, a:pairPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    elseif a:scaleMode == 3 || a:scaleMode == 4
        let [vl, vc, cl ,cc] = scale#pair#GetPairCurrent([cl, cc], a:pairPatterns.opening, a:pairPatterns.closing)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#pair#GetPairOutward(cursorPos, openPattern, closePattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [cl, cc] = searchpairpos(a:openPattern, '', a:closePattern, 'W')
        call cursor(vl, vc)
        let [vl, vc] = searchpairpos(a:openPattern, '', a:closePattern, 'bW')
    else
        let [cl, cc] = searchpairpos(a:openPattern, '', a:closePattern, 'bW')
        call cursor(vl, vc)
        let [vl, vc] = searchpairpos(a:openPattern, '', a:closePattern, 'W')
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#pair#GetPairInward(cursorPos, openPattern, closePattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let [tvl, tvc, tcl, tcc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [tcl, tcc] = searchpos(a:closePattern, 'bW', vl)
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:openPattern, 'W', cl)
        if tvl != 0 && tcl != 0 && tcl >= tvl && tcc >= tvc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    else
        let [tcl, tcc] = searchpos(a:openPattern, 'W', vl)
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:closePattern, 'bW', cl)
        if tvl != 0 && tcl != 0 && tvl >= tcl && tvc >= tcc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    endif
    return [tvl, tvc, tcl, tcc]
endfunction

function! scale#pair#GetPairCurrent(cursorPos, openPattern, closePattern)
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
