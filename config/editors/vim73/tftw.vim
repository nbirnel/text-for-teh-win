syntax off
setlocal textwidth=78
setlocal filetype=text
filetype indent off
setlocal noautoindent
setlocal nosmartindent
set spell
setlocal spelllang=en_us

nnoremap <leader>d :normal! a<c-r>=<SID>Date()<cr><cr>
nnoremap <leader>t :normal! a<c-r>=<SID>Time()<cr><cr>
nnoremap <leader>m :normal! a<c-r>=<SID>Me()<cr><cr>

function! <SID>Date() 
    return strftime("%Y-%m-%d")
endfunction

function! <SID>Time() 
    return strftime("%Y-%m-%d %H:%M")
endfunction

function! <SID>Me()
    return expand($USERNAME)
endfunction

