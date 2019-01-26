
function! assimilate#findstart()
    " locate the start of the word
    let line = getline('.')
    echom 'line ' . line
    let start = col('.') - 1
    " echom 'start ' . start
    while start > 0 && line[start - 1] =~ '\f'
        let start -= 1
    endwhile
    echom 'start is ' . start
    return start
endfunction

function! assimilate#find_include(findstart, base, folder)
    if a:findstart
        return assimilate#findstart()
    else
        " find files matching with "a:base"
        " echom 'a:base [' . a:base . ']'
        let l:trimmed = matchstr(a:base, '\S*$')
        let res = []
        let files = expand("./" . a:folder . "/**", 1, 1)
        for f in files
            " let m = matchstr(f, '[^\(./' . a:folder . '/\)].*\.')
            let m = matchstr(f, a:folder . '/.*')
            let m = m[strlen(a:folder . '/'):]
            let m = fnamemodify(m, ":r")
            " echom m . ' =~ ^' . a:base
            " if m =~ '^' . a:base
            if m =~ l:trimmed
                " echom 'adding ' . m
                call add(res, m)
            endif
        endfor
        return res
    endif
endfunction

function! assimilate#list_include(findstart, base) abort
    return assimilate#find_include( a:findstart, a:base, 'include')
endfunction
