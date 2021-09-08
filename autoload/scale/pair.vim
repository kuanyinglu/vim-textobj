" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
function! scale#pair#GetPairs(cursorPos, scaleMode, multiplier)
    let [vl, vc, cl, cc] = a:cursorPos
    let [ovl, ovc, ocl, occ] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    for pattern in g:blockPatterns
        call util#MakeSelection(a:cursorPos)
        let [tvl, tvc, tcl, tcc] = scale#pair#GetPair(pattern, a:scaleMode, a:multiplier)
        if tvl == 0
            continue
        endif
        " echom [tvl, tvc, tcl, tcc]
        if a:scaleMode == 1 || a:scaleMode == 2
            if (selectionForward && (tcl > ocl || (tcl == ocl && tcc > occ)) && (vl == ovl || (tcl < cl || (tcl == cl && tcc > cc)))) || (!selectionForward && (tvl > ovl || (tvl == ovl && tvc > ovc)) && (vl == ovl || (tvl < vl || (tvl == vl && tvc < vc))))
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
            if (selectionForward && (tcl < ocl || (tcl == ocl && tcc < occ)) && (vl == ovl || (tcl > cl || (tcl == cl && tcc > cc)))) || (!selectionForward && (tvl < ovl || (tvl == ovl && tvc < ovc)) && (vl == ovl || (tvl > vl || (tvl == vl && tvc > vc))))
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
        endif
    endfor
    return [vl, vc, cl ,cc]
endfunction

function! scale#pair#GetPair(pairPatterns, scaleMode, multiplier)
    let multiplier = a:multiplier
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
        for _ in range(multiplier - 1)
            let [tvl, tvc, tcl ,tcc] = scale#pair#GetPairOutward([vl, vc, cl ,cc], a:pairPatterns.opening, a:pairPatterns.closing)
            if tvl == 0 || tcl == 0
                return [vl, vc, cl ,cc]
            else
                let [vl, vc, cl ,cc] = [tvl, tvc, tcl ,tcc]
            endif
        endfor
    elseif a:scaleMode == -1 || a:scaleMode == -2
        if a:scaleMode == -1
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
        for _ in range(multiplier - 1)
            let [tvl, tvc, tcl ,tcc] = scale#pair#GetPairInward([vl, vc, cl ,cc], a:pairPatterns.opening, a:pairPatterns.closing)
            if tvl == 0 || tcl == 0
                return [vl, vc, cl ,cc]
            else
                let [vl, vc, cl ,cc] = [tvl, tvc, tcl ,tcc]
            endif
        endfor
    else
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#pair#GetPairOutward(cursorPos, openPattern, closePattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        call cursor(vl, vc)
        let [vl, vc] = searchpairpos(a:openPattern, '', a:closePattern, 'bW')
        call cursor(cl, cc)
        let [cl, cc] = searchpairpos(a:openPattern, '', a:closePattern, 'W')
    else
        call cursor(cl, cc)
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
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:openPattern, 'W', cl)
        call cursor(cl, cc)
        let [tcl, tcc] = searchpos(a:closePattern, 'bW', vl)
        if tvl != 0 && tcl != 0 && tcl >= tvl && tcc >= tvc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    else
        call cursor(cl, cc)
        let [tcl, tcc] = searchpos(a:openPattern, 'W', vl)
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:closePattern, 'bW', cl)
        if tvl != 0 && tcl != 0 && tvl >= tcl && tvc >= tcc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    endif
    return [tvl, tvc, tcl, tcc]
endfunction
