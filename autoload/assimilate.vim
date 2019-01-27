" = FINDPATH BEAHAVIOR ======================================================
" control suffix stripping behavior
let s:keep_suffixes = 1
function! assimilate#strip_suffixes() abort
    let s:keep_suffixes = 0
endfunction
function! assimilate#keep_suffixes() abort
    let s:keep_suffixes = 1
endfunction

" control include_path inclusion
let s:keep_path = 1
function! assimilate#strip_include_path() abort
    let s:keep_path = 0
endfunction
function! assimilate#keep_path() abort
    let s:keep_path = 1
endfunction

function! assimilate#find_in_folder(base, search_path) abort
    let l:path_qualifier = './'
    if a:search_path[0] ==# '/'
        let l:path_qualifier = ''
    endif
    " trim any leading spaces that usercomplete might add
    let l:trimmed = matchstr(a:base, '\S*$')
    let l:files = glob(l:path_qualifier . a:search_path . '/**', 1, 1)
    " trim potential ldeading noise, such as './'
    call map( l:files, { k, v -> matchstr( v, a:search_path . '.*' ) } )
    if ! s:keep_path
        call map( l:files, { k, v -> v[strlen(a:search_path . '/'):] } )
    endif

    let l:matches = []
    for l:match in l:files
        " let l:match = l:match[strlen(a:search_path . '/'):]
        if ! s:keep_suffixes
            let l:match = fnamemodify(l:match, ':r')
        endif
        if l:match =~ l:trimmed
            call add(l:matches, l:match)
        endif
    endfor
    return l:matches
endfunction

function! assimilate#findstart()
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~# '\f'
        let start -= 1
    endwhile
    return start
endfunction

function! assimilate#find_include(findstart, base, search_path)
    if a:findstart
        return assimilate#findstart()
    else
        return assimilate#find_in_folder(a:base, a:search_path)
    endif
endfunction

function! assimilate#list_include(findstart, base) abort
    return assimilate#find_include( a:findstart, a:base, 'include')
endfunction
