" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
function! scale#quote#GetQuotes(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let [ovl, ovc, ocl, occ] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    for pattern in g:quotePatterns
        call util#MakeSelection(a:cursorPos)
        let [tvl, tvc, tcl, tcc] = scale#quote#GetOneQuote(pattern, a:scaleMode)
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
        endif
    endfor
    return [vl, vc, cl ,cc]
endfunction

function! scale#quote#GetOneQuote(quotePattern, scaleMode)
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
        let [vl, vc, cl ,cc] = scale#quote#GetQuoteOutward([vl, vc, cl, cc], a:quotePattern)
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
        let [vl, vc, cl ,cc] = scale#quote#GetQuoteInward([vl, vc, cl, cc], a:quotePattern)
        if vl == 0 || cl == 0
            return [0, 0, 0, 0]
        endif
    endif
    return [vl, vc, cl ,cc]
endfunction
function! scale#quote#GetQuoteOutward(cursorPos, pattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [cl, cc] = searchpos(a:pattern, 'W')
        call cursor(vl, vc)
        let [vl, vc] = searchpos(a:pattern, 'bW')
    else
        let [cl, cc] = searchpos(a:pattern, 'bW')
        call cursor(vl, vc)
        let [vl, vc] = searchpos(a:pattern, 'W')
    endif
    return [vl, vc, cl ,cc]
endfunction

function! scale#quote#GetQuoteInward(cursorPos, pattern)
    let [vl, vc, cl, cc] = a:cursorPos
    let [tvl, tvc, tcl, tcc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let [tcl, tcc] = searchpos(a:pattern, 'bW', vl)
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:pattern, 'W', cl)
        if tvl != 0 && tcl != 0 && tcl >= tvl && tcc >= tvc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    else
        let [tcl, tcc] = searchpos(a:pattern, 'W', vl)
        call cursor(vl, vc)
        let [tvl, tvc] = searchpos(a:pattern, 'bW', cl)
        if tvl != 0 && tcl != 0 && tvl >= tcl && tvc >= tcc
            let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
        endif
    endif
    return [tvl, tvc, tcl, tcc]
endfunction