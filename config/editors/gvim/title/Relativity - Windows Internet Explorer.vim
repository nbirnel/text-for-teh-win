" \t yields date and time, and puts us back in append mode
nnoremap <leader>t :normal! a<c-r>=<SID>DateTime()<cr><cr>a

function! <SID>DateTime() 
    return strftime("%Y-%m-%d %H:%M")
endfunction

ab edisc Discovering in ecap <esc>\t
ab eproc Processing in ecap <esc>\t
ab eexp Exporting from ecap <esc>\t
ab movv Moving to Palo Alto <esc>\t
ab movs Moving to Seattle <esc>\t
ab rexp Exporting from relativity <esc>\t
ab rocr Ocr'ing in relativity <esc>\t
ab rload Loading to relativity <esc>\t
