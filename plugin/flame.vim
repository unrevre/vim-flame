if exists('g:flame_loaded')
    finish
endif
let g:flame_loaded = 1

augroup flame
    autocmd!
    autocmd BufReadPre,FileReadPre,BufEnter * call flame#init()
augroup END

nnoremap <unique> <Plug>EnableFlame :call flame#enable()<CR>
nnoremap <unique> <Plug>DisableFlame :call flame#disable()<CR>
nnoremap <unique> <Plug>ToggleFlame :call flame#toggle()<CR>
