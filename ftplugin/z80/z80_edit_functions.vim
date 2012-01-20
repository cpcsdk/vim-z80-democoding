" File: z80_edit_functions.vim
" Author: Krusty/Benediction
" Description:  This file contains useful functions to help z80 development
" Last Modified: janvier 20, 2012



" Z80 assembler conversion {{{

" Split a line with several commands in several independent lines
" (allow to easily convert files from one assembly language to another one)
function! Z80SplitInstructionsInSeveralLines() range

    let lnum          = a:firstline
    let s:linecounter = 0

    while lnum <= a:lastline
        let s:line = getline(lnum + s:linecounter)

        " Works only on right lines
        if  -1 == match(s:line, '.*:.*')
            let lnum = lnum + 1
            continue
        endif


        let s:instructions = split(s:line, ':')
        let s:empty = matchstr(s:line, '^\s*')
        let s:code = substitute(s:line, '^\s*\(.*$\)', '\1', '')
        let s:i=1


        call append(lnum + s:linecounter, s:empty.'; '.s:code.' {{{ Automatic expanding')
        " Copy each instruction
        for instruction in s:instructions
            if s:i == 1
                call append(lnum+s:i+s:linecounter, instruction)
            else
                call append(lnum+s:i+s:linecounter, s:empty.instruction)
            endif
            let s:i=s:i +1
        endfor
        call append(lnum+s:i+s:linecounter, s:empty.'; }}}')
        
        " Delete line
        exec (lnum+s:linecounter)."d"

        let s:linecounter = s:linecounter + s:i 
        let lnum = lnum + 1
    endwhile
endfunction

function! Z80WholeFileSplitInstructionsInSeveralLines()
	exec "%call Z80SplitInstructionsInSeveralLines()"
endfunction

" }}}
