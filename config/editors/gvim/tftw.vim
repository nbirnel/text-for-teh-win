syntax off
setlocal textwidth=78
setlocal filetype=text
filetype indent off
setlocal noautoindent
setlocal nosmartindent
set spell
setlocal spelllang=en_us

nnoremap <leader>t :normal! a<c-r>=strftime("%Y-%m-%d %H:%M")<cr><cr>a <Esc>
nnoremap <leader>d :normal! a<c-r>=strftime("%Y-%m-%d")<cr><cr>a <Esc>
