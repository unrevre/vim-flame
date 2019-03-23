function! flame#annotation(buf, line)
    let l:gitbase_path = fnamemodify(b:gitdir_path, ':h')
    let l:gitcommand = 'git --git-dir='.b:gitdir_path
                \.' --work-tree='.l:gitbase_path
    let l:blame = systemlist(l:gitcommand.' annotate --contents - '
                \.expand('%:p').' --porcelain -L '.a:line.','.a:line.
                \' -M', a:buf)
    if v:shell_error > 0
        echo l:blame[-1]
        return
    endif
    let l:commit = strpart(l:blame[0], 0, 40)
    let l:format = '%an | %ar | %s'
    if l:commit ==# '0000000000000000000000000000000000000000'
        let l:annotation = ['Not committed yet']
    else
        let l:annotation = systemlist(l:gitcommand.' show '.l:commit.
                    \' --format="'.l:format.'"')
    endif
    if v:shell_error > 0
        echo l:annotation[-1]
        return
    endif
    return l:annotation[0]
endfunction

function! flame#line(...)
    echo ''
    let l:comment = flame#annotation(bufnr('%'), line('.'))
    if get(a:, 0, 0)
        let l:comment = line('.').': '.l:comment
    endif
    echom l:comment
endfunction

function! flame#init()
    if !exists('b:gitdir_path')
        let b:gitdir_path = git#dir(expand('%:p:h'))
    endif
    let b:flame_toggle = function('flame#enable')
endfunction

function! flame#enable()
    augroup flame
        autocmd CursorMoved <buffer> call flame#line()
    augroup END
    call flame#line()
    let b:flame_toggle = function('flame#disable')
endfunction

function! flame#disable()
    echom ''
    autocmd! flame * <buffer>
    let b:flame_toggle = function('flame#enable')
endfunction

function! flame#toggle()
    call b:flame_toggle()
endfunction
