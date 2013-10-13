" Ensemble of utility function for z80 files written for vasm
" (note that it could also work with other assemblers)
"
" Romain Giot
" GPL


" Return 1st and last line of the macro
function! VASMSearchMacro(name) 

    let l:macroline = search('\<macro\>\s\+\<'.a:name.'\>')
    if l:macroline>0
        let l:endmacroline = searchpair('macro', '', 'endmacro')
        if l:endmacroline==0
            let l:endmacroline = searchpair('macro', '', 'endm')
        endif
        if l:endmacroline==0
            echoerr 'End of macro "'.a:name.'" not found'
        endif


    else
        echoerr 'Macro "'.a:name.'" not found'
    endif

    let l:res = []
    call add(l:res, l:macroline)
    call add(l:res, l:endmacroline)

    return l:res
endfunction

" Return the name of the macro called on the current line
function! VASMGetMacroNameOfCurrentLine()
    let l:line = getline('.')
	let l:name = substitute(l:line, '^\s*\<\(.*\)\>.*$', '\1', '')

    unlet l:line
    return l:name
endfunction

" Returns an ordered list on the name of the arguments
function! VASMExtractArgsName(name, line)
    let l:strargnames = substitute(a:line, '^\s*macro\s*'.a:name.'\s*,\(.*\)', '\1', '')
    let l:lstargnames = []
    for l:argname in split(l:strargnames,',')
        let l:arg =  substitute(l:argname, '^\s*\(.*\)\s*$', '\1', '')
        call add(l:lstargnames, l:arg)
    endfor
    return l:lstargnames
endfunction

" Returns an ordered list on the value of the arguments
function! VASMExtractArgsValue(name, line)
    let l:strargvalues = substitute(a:line, '^\s*'.a:name.'\s*\(.*\)\s*$', '\1', '')
    let l:lstargvalues = []
    for l:argvalue in split(l:strargvalues,',')
        let l:arg =  substitute(l:argvalue, '^\s*\(.*\)\s*$', '\1', '')
        call add(l:lstargvalues, l:arg)
    endfor
    return l:lstargvalues
endfunction

" Expand the VASM macro of the current line
" 1. Get the name of the macro
" 2. Get the arguments of the macro
" 3. Replace the content of the arguments
function! VASMExpandMacroOfCurrentLine()
    " Get the various information on the line
    let l:cursor = getpos('.')
    let l:linenumber = line('.')
    let l:line       = getline('.')
    let l:name     = VASMGetMacroNameOfCurrentLine()
    let l:lines    = VASMSearchMacro(l:name)
    let l:lstargnames = VASMExtractArgsName(l:name, getline(l:lines[0]))
    let l:lstargvalues = VASMExtractArgsValue(l:name,l:line)

    if len(l:lstargnames) != len(l:lstargvalues)
        echoerr 'Coding error! Number of detected arguments different of the number of given parameters!'
        return
    endif

    " Build the replace string
    let l:str = []
    let l:i = 1 " skip the line containing macro string
    while l:i < (l:lines[1] - l:lines[0])
        let l:currentstr = getline(l:lines[0] + l:i)
        for l:j in range(len(l:lstargnames))
            let l:currentstr = substitute(l:currentstr, '\\'.l:lstargnames[j], l:lstargvalues[j],'g')
        endfor
        call add(l:str, l:currentstr)
        let l:i +=1
    endwhile

    " Replace current string by the new content
    call setpos('.', l:cursor)
    call append(l:linenumber, l:str)
    :d
endfunction

