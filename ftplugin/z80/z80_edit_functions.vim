" File: z80_edit_functions.vim
" Author: Krusty/Benediction
" Description:  This file contains useful functions to help z80 development
" Last Modified: janvier 20, 2012

if exists('did_z80_edit_functions') || &cp || version < 700
	finish
endif
let did_z80_edit_functions = 1

" Z80 assembler conversion {{{

" Split a line with several commands in several independent lines
" (allow to easily convert files from one assembly language to another one)
" Mainly written to convert sjamsplus source to vasm source
function! Z80SplitInstructionsInSeveralLines() range

    let lnum          = a:firstline
    let s:linecounter = 0

    while lnum <= a:lastline
        let s:line = getline(lnum + s:linecounter)

        " Works only on right lines
		" and when : is not after a comment
        if  -1 == match(s:line, '.*:.*')  ||  -1 != match(s:line, '^\s*[^:]*;\|\*')
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
                call append(lnum+s:i+s:linecounter, ' '.instruction)
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


" Remove the comments in C format and replace them by ;
function Z80TranslateCComments()
	" /**
	try 
		exec "%s/\\(\\s*\\)\\/\\*\\*/\\1 ;;/"
	catch
	endtry

	" /*
	try 
	exec "%s/\\(\\s*\\)\\/\\*/\\1 ;/"
	catch
	endtry


	try 
	exec "%s/\\(\\s*\\)\\*\\//\\1;/"
	catch
	endtry


	" * "
	try 
	exec "%s/\\(\\s*\\)\\*/\\1;/"
	catch
	endtry


endfunction


" Convert the source file from sjamsplus format to vasm format.
" Conversion involves the following process:
"  - Splitting of lines with several instructions
"  - Translate sjasmplus comments
"  - Remove output command
"  - use the write macro syntax
"
"  TODO write the macro transformation function
"  TODO protect macro arguments
function! Z80Sjamsplus2vasm()
	call Z80WholeFileSplitInstructionsInSeveralLines()
	call Z80TranslateCComments()

	" TODO use a list to comment these things

	" remove the output command
	try
		exec "%s/^\\(\\s*output\\s*.*$\\)/;\\1 ; Automatic remove/"
	catch
	endtry

	" comment the assertions which are not available :(
	try
		exec "%s/^\\(\\s*assert\\s*.*$\\)/;\\1 ; Automatic remove/"
	catch
	endtry

	" Repetition
	try
		exec "%s/\\(.*[^e]\\)dup\\(\\s*.*\\)/\\1repeat\\2/"
	catch
	endtry
	try
		exec "%s/\\(.*\\)edup\\(\\s*.*\\)/\\1endrepeat\\2/"
	catch
	endtry

endfunction

" }}}
