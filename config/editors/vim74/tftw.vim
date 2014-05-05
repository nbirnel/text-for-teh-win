syntax off
setlocal textwidth=78
setlocal filetype=text
filetype indent off
setlocal noautoindent
setlocal nosmartindent
set spell
setlocal spelllang=en_us

nnoremap <leader>d :normal! a<c-r>=<SID>Date()<cr><cr>a <esc>
nnoremap <leader>t :normal! a<c-r>=<SID>Time()<cr><cr>a <esc>
nnoremap <leader>m :normal! a<c-r>=<SID>Me()<cr><cr>a <esc>
nnoremap <leader>q :normal! a<c-r>=<SID>Stamp()<cr><cr>a <esc>

function! <SID>Date() 
    return strftime("%Y-%m-%d")
endfunction

function! <SID>Time() 
    return strftime("%Y-%m-%d %H:%M")
endfunction

function! <SID>Me()
    return expand($USERNAME)
endfunction

function! <SID>Stamp()
    let l:t = <SID>Time()
    let l:m = <SID>Me()
    return printf('%s - %s', l:t, l:m)
endfunction
