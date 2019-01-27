
function! assimilate#findstart()
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~# '\f'
        let start -= 1
    endwhile
    return start
endfunction

" control suffix stripping behavior
let s:keep_suffixes = 1
function! assimilate#strip_suffixes() abort
    let s:keep_suffixes = 0
endfunction

function! assimilate#find_in_folder(base, folder) abort
    let l:path_qualifier = './'
    if a:folder[0] ==# '/'
        let l:path_qualifier = ''
    endif
    " trim leading spaces from path
    let l:trimmed = matchstr(a:base, '\S*$')
    let l:matches = []
    let l:files = expand(l:path_qualifier . a:folder . '/**', 1, 1)
    for l:match in l:files
        " trim leading slash (match on folder path
        let l:match = matchstr(l:match, a:folder . '/.*')
        " trim folder from path
        let l:match = l:match[strlen(a:folder . '/'):]
        if ! s:keep_suffixes
            let l:match = fnamemodify(l:match, ':r')
        endif
        if l:match =~ l:trimmed
            call add(l:matches, l:match)
        endif
    endfor
    return l:matches
endfunction

function! assimilate#find_include(findstart, base, folder)
    if a:findstart
        return assimilate#findstart()
    else
        return assimilate#find_in_folder(a:base, a:folder)
    endif
endfunction

function! assimilate#list_include(findstart, base) abort
    return assimilate#find_include( a:findstart, a:base, 'include')
endfunction
