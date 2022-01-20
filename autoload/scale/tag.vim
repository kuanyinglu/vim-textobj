" scaleMode 1 - expand, end
"           -1 - shrink, end
"           2 - expand, inner 
"           -2 - shrink, inner
"           3 - current
"           4 - current, inner
function! scale#tag#GetTags(cursorPos, scaleMode)
    let [vl, vc, cl, cc] = a:cursorPos
    let [ovl, ovc, ocl, occ] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    let posLists = scale#tag#GetTagPositions(a:cursorPos, a:scaleMode)
    for pos in posLists
        let [tvl, tvc, tcl, tcc] = pos
        if tvl == 0 || tcl == 0
            continue
        endif
        if a:scaleMode == 1 || a:scaleMode == 2
            if a:scaleMode == 2
                if selectionForward
                    let [tcl, tcc] = util#GetPrevPos(tcl, tcc)
                    let [tvl, tvc] = util#GetNextPos(tvl, tvc)
                else
                    let [tcl, tcc] = util#GetNextPos(tcl, tcc)
                    let [tvl, tvc] = util#GetPrevPos(tvl, tvc)
                endif
            endif
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let validSelection = (selectionForward && ((tcl > ocl || (tcl == ocl && tcc > occ)) || (tvl < ovl || (tvl == ovl && tvc < ovc)))) || (!selectionForward && ((tvl > ovl || (tvl == ovl && tvc > ovc)) || (tcl < ocl || (tcl == ocl && tcc < occ))))
            let closerSelection = (selectionForward && ((tcl < cl || (tcl == cl && tcc < cc)) || (tvl > vl || (tvl == vl && tvc > vc)))) || (!selectionForward && ((tvl < vl || (tvl == vl && tvc < vc)) || (tcl > cl || (tcl == cl && tcc > cc))))
            if (validSelection && firstSelection) || (validSelection && closerSelection)
                let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
            endif
        elseif a:scaleMode == -1 || a:scaleMode == -2
            if a:scaleMode == -2
                if selectionForward
                    let [tcl, tcc] = util#GetPrevPos(tcl, tcc)
                    let [tvl, tvc] = util#GetNextPos(tvl, tvc)
                else
                    let [tcl, tcc] = util#GetNextPos(tcl, tcc)
                    let [tvl, tvc] = util#GetPrevPos(tvl, tvc)
                endif
            endif
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let validSelection = (selectionForward && ((tcl < ocl || (tcl == ocl && tcc < occ)) || (tvl > ovl || (tvl == ovl && tvc > ovc)))) || (!selectionForward && ((tvl < ovl || (tvl == ovl && tvc < ovc)) || (tcl > ocl || (tcl == ocl && tcc > occ))))
            let closerSelection = (selectionForward && ((tcl > cl || (tcl == cl && tcc > cc)) || (tvl < vl || (tvl == vl && tvc < vc)))) || (!selectionForward && ((tvl > vl || (tvl == vl && tvc > vc)) || (tcl < cl || (tcl == cl && tcc < cc))))
            if (validSelection && firstSelection) || (validSelection && closerSelection)
                let [vl, vc, cl, cc] = [tvl, tvc, tcl, tcc]
            endif
        elseif a:scaleMode == 3 || a:scaleMode == 4
            let firstSelection = ovl == vl && ovc == vc && ocl == cl && occ == cc
            let validSelection = (tcl > ocl || (tcl == ocl && tcc >= occ)) && (tvl < ovl || (tvl == ovl && tvc <= ovc))
            let closerSelection = (tcl < cl || (tcl == cl && tcc < cc)) || (tvl > vl || (tvl == vl && tvc > vc))
            if (validSelection && firstSelection) || (validSelection && closerSelection)
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

function! scale#tag#GetTagPositions(cursorPos, scaleMode)
    let list = []
    if a:scaleMode == 1 || a:scaleMode == 2
        let list = scale#tag#GetTagOutward(a:cursorPos, a:scaleMode)
    elseif a:scaleMode == -1 || a:scaleMode == -2
        let list = scale#tag#GetTagInward(a:cursorPos, a:scaleMode)
    elseif a:scaleMode == 3 || a:scaleMode == 4
        let list = scale#tag#GetTagCurrent(a:cursorPos, a:scaleMode)
    endif
    return list
endfunction

function! scale#tag#GetTagOutward(cursorPos, scaleMode)
    let list = []
    let [sl, sc, el, ec] = a:cursorPos 
    let done = 0
    let [ovl, ovc, ocl, occ] = a:cursorPos
    let selectionForward = ocl > ovl || (ocl == ovl && occ >= ovc)
    if selectionForward
        call cursor(ovl, ovc)
    endif
    while done < 2
        let [sl, sc, el, ec] = scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, 'bW'), a:scaleMode)
        if selectionForward && (sl < ovl || (sl == ovl && sc < ovc)) && (el > ocl || (el == ocl && ec > occ))
            let list = add(list, [sl, sc, el, ec])
            let done += 1
        elseif !selectionForward && (sl < ocl || (sl == ocl && sc < occ)) && (el > ovl || (el == ovl && ec > ovc))
            let list = add(list, [el, ec, sl, sc])
            let done += 1
        elseif sl == 0 || el == 0
            let done += 1
        endif
    endwhile

    let [sl, sc, el, ec] = [ovl, ovc, ocl, occ] 
    let done = 0
    if selectionForward
        call cursor(ocl, occ)
    else
        call cursor(ovl, ovc)
    endif
    while done < 2
        let [sl, sc, el, ec] = scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, 'W'), a:scaleMode)
        if selectionForward && (sl < ovl || (sl == ovl && sc < ovc)) && (el > ocl || (el == ocl && ec > occ))
            let list = add(list, [sl, sc, el, ec])
            let done += 1
        elseif !selectionForward && (sl < ocl || (sl == ocl && sc < occ)) && (el > ovl || (el == ovl && ec > ovc))
            let list = add(list, [el, ec, sl, sc])
            let done += 1
        elseif sl == 0 || el == 0
            let done += 1
        endif
    endwhile
    return list
endfunction


function! scale#tag#GetTagInward(cursorPos, scaleMode)
    let list = []
    let [vl, vc, cl, cc] = a:cursorPos
    let selectionForward = cl > vl || (cl == vl && cc >= vc)
    if selectionForward
        let list = add(list, scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, 'cW'), a:scaleMode))
        call cursor(cl, vc)
        let list = add(list, scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, 'bW'), a:scaleMode))
        call cursor(vl, vc)
        let list = add(list, scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, 'cbW'), a:scaleMode))
        call cursor(vl, vc)
        let list = add(list, scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, 'W'), a:scaleMode))
    else
        let [sl, sc, el, ec] = scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, 'cbW'), a:scaleMode)
        let list = add(list, [el, ec, sl, sc])
        call cursor(cl, vc)
        let [sl, sc, el, ec] = scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, 'W'), a:scaleMode)
        let list = add(list, [el, ec, sl, sc])
        call cursor(vl, vc)
        let [sl, sc, el, ec] = scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, 'cW'), a:scaleMode)
        let list = add(list, [el, ec, sl, sc])
        call cursor(vl, vc)
        let [sl, sc, el, ec] = scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, 'bW'), a:scaleMode)
        let list = add(list, [el, ec, sl, sc])
    endif
    return list
endfunction

function! scale#tag#GetTagCurrent(cursorPos, scaleMode)
    let list = []
    let [_, _, cl, cc] = a:cursorPos
    let [_, _, ocl, occ] = a:cursorPos
    let done = 0
    let firstRun = 0
    while done < 1
        let flag = 'W'
        if firstRun == 0
            let flag = 'cW'
            let firstRun = 1
        endif
        let [sl, sc, el, ec] = scale#tag#GetStartTag(searchpos(g:TextObj_tagPatterns.tagClosing, flag), a:scaleMode)
        if (sl < ocl || (sl == ocl && sc <= occ)) && (el > ocl || (el == ocl && ec >= occ))
            let list = add(list, [sl, sc, el, ec])
            let done += 1
        elseif sl == 0 || el == 0
            let done += 1
        endif
    endwhile

    call cursor(ocl, occ)
    let [sl, sc, el, ec] = [ocl, occ, ocl, occ] 
    let done = 0
    let firstRun = 0
    while done < 1
        let flag = 'bW'
        if firstRun == 0
            let flag = 'cbW'
            let firstRun = 1
        endif
        let [sl, sc, el, ec] = scale#tag#GetEndTag(searchpos(g:TextObj_tagPatterns.tagOpening, flag), a:scaleMode)
        if (sl < ocl || (sl == ocl && sc <= occ)) && (el > ocl || (el == ocl && ec >= occ))
            let list = add(list, [sl, sc, el, ec])
            let done += 1
        elseif sl == 0 || el == 0
            let done += 1
        endif
    endwhile
    return list
endfunction

function! scale#tag#GetEndTag(pos, scaleMode)
    let [sl, sc] = a:pos
    let [osl, osc] = a:pos
    let [el, ec] = [0, 0]
    if sl == 0
        return [0, 0, 0, 0]
    endif
    let [tl, tc] = searchpos(g:TextObj_tagPatterns.endTagName, 'Wn')
    let tagName = getline('.')[sc : tc - 1]
    let endPattern = '<\/' . tagName
    if a:scaleMode == 1 || a:scaleMode == -1 || a:scaleMode == 3
        let [el, ec] = searchpairpos('<' . tagName, '', endPattern, 'W')
        let [el, ec] = searchpairpos('<', '', '>', 'Wn')
    else
        let [sl, sc] = searchpairpos('<', '', '>', 'Wn')
        let [el, ec] = searchpairpos('<' . tagName, '', endPattern, 'Wn')
    endif
    call cursor(osl, osc)
    return [sl, sc, el, ec]
endfunction

function! scale#tag#GetStartTag(pos, scaleMode)
    let [el, ec] = a:pos
    let [oel, oec] = a:pos
    let [sl, sc] = [0, 0]
    if el == 0
        return [0, 0, 0, 0]
    endif
    let [tl, tc] = searchpos(g:TextObj_tagPatterns.endTagName, 'Wn')
    let tagName = getline('.')[ec + 1: tc - 1]
    let startPattern = '<' . tagName
    if a:scaleMode == 1 || a:scaleMode == -1 || a:scaleMode == 3
        let [el, ec] = searchpairpos('<', '', '>', 'Wn')
        let [sl, sc] = searchpairpos(startPattern, '', '<\/' . tagName, 'bWn')
    else
        let [sl, sc] = searchpairpos(startPattern, '', '<\/' . tagName, 'bW')
        let [sl, sc] = searchpairpos('<', '', '>', 'Wn')
    endif
    call cursor(oel, oec)
    return [sl, sc, el, ec]
endfunction