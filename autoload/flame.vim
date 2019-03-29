function! flame#annotation(buf, line)
    let l:gitcommand = 'git --git-dir='.b:gitdir_path
                \.' --work-tree='.fnamemodify(b:gitdir_path, ':h')
    let l:blame = systemlist(l:gitcommand.' annotate --contents - '
                \.expand('%:p').' --porcelain -L '.a:line.','.a:line.
                \' -M', a:buf)
    if v:shell_error > 0 | echo l:blame[-1] | return | endif
    let l:commit = strpart(l:blame[0], 0, 40)
    if l:commit ==# '0000000000000000000000000000000000000000'
        let l:annotation = ['Not committed yet']
    else
        let l:annotation = systemlist(l:gitcommand.' show '.l:commit.
                    \' --format="%an | %ar | %s"')
    endif
    if v:shell_error > 0 | echo l:annotation[-1] | return | endif
    return l:annotation[0]
endfunction

function! s:handler()
    function! s:line() closure
        echo ''
        echom flame#annotation(bufnr('%'), line('.'))
    endfunction

    if has('timers') && has('lambda')
        let l:timer = 0

        function! s:debounce() closure
            call timer_stop(l:timer)
            let l:timer = timer_start(50, {-> s:line()})
        endfunction

        return 's:debounce'
    endif

    return 's:line'
endfunction

function! flame#init()
    if !exists('b:gitdir_path')
        let b:gitdir_path = git#dir(expand('%:p:h'))
    endif
    let s:on_cursor_movement = function(s:handler())
    let b:flame_toggle = function('flame#enable')
endfunction

function! flame#line()
    call s:on_cursor_movement()
endfunction

function! flame#enable()
    augroup flame
        autocmd CursorMoved <buffer> call s:on_cursor_movement()
    augroup END

    call s:on_cursor_movement()
    let b:flame_toggle = function('flame#disable')
endfunction

function! flame#disable()
    echo ''
    autocmd! flame * <buffer>
    let b:flame_toggle = function('flame#enable')
endfunction

function! flame#toggle()
    call b:flame_toggle()
endfunction
