if exists('g:flame_loaded')
    finish
endif
let g:flame_loaded = 1

augroup flame
    autocmd!
    autocmd BufReadPre,FileReadPre,BufEnter * call flame#init()
augroup END

command! EnableFlame :call flame#enable()
command! DisableFlame :call flame#disable()
command! ToggleFlame :call flame#toggle()
