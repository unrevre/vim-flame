if exists('g:flame_loaded')
    finish
endif
let g:flame_loaded = 1

augroup flame
    autocmd!
    autocmd BufReadPre,FileReadPre * call flame#init()
augroup END

nnoremap <unique> <Plug>(FlameLine) :call flame#line()<CR>

nnoremap <unique> <Plug>(FlameToggle) :call flame#toggle()<CR>
nnoremap <unique> <Plug>(FlameEnable) :call flame#enable()<CR>
nnoremap <unique> <Plug>(FlameDisable) :call flame#disable()<CR>
