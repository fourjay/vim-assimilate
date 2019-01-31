" = FINDPATH BEAHAVIOR ======================================================
function! assimilate#get_config(key)
    if exists('b:assimilate_settings')
        return b:assimilate_settings[a:key]
    else
        return g:assimilate_settings[a:key]
    endif
endfunction
" = MAIN FILE SEARCH ===========================================================
function! assimilate#find_in_folder(base, search_path) abort
    let l:path_qualifier = './'
    " check if path is absolute
    if a:search_path[0] ==# '/'
        let l:path_qualifier = ''
    endif
    " trim any leading spaces that usercomplete might add
    let l:trimmed = matchstr(a:base, '\S*$')
    let l:files = glob(l:path_qualifier . a:search_path . '/**', 1, 1)
    " trim potential ldeading noise, such as './'
    call map( l:files, { k, v -> matchstr( v, a:search_path . '.*' ) } )
    if assimilate#get_config('trim_search_path') && ! assimilate#get_config('keep_whole_path') 
        call map( l:files, { k, v -> v[strlen(a:search_path . '/'):] } )
    endif
    if ! assimilate#get_config('keep_suffixes')
        call map( l:files, { k, v -> fnamemodify(v, ':r') } )
    endif
    if assimilate#get_config('trim_whole_path')
        call map(l:files, { k, v -> substitute( v, '^[^/]*[/]*', '', '') } )
    endif

    call filter( l:files, { k, v -> v =~? l:trimmed } )
    return l:files
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

function! assimilate#get_base()
    let l:start = assimilate#findstart()
    let l:end = col('.')
    return strpart(getline('.'), l:start, l:end - l:start)
endfunction

function! assimilate#completer(path)
    let l:base = assimilate#get_base()
    let l:start = assimilate#findstart()
    let l:return = assimilate#find_in_folder(l:base, a:path)
    call complete(l:start, l:return)
    return ''
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
