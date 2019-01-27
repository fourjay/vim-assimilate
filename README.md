# vim-assimilate - include path automcomplete

`C` is vim's "first among equals" language, and vim's support for C includes is
strong. But many other languages use inclusion, with semantics and assumptions
that do not match C. This library is an attempt to craft a general autocomplete
for inclusion autocompletion in vim.

The basic use case:

    function! CustomComplete(findstart base)
        return assimilate#find_include( a:findstart, a:base, 'include/path' )
    endfunction
    set completefunc=CustomComplete

This will map `<C-X><C-U>` to 1. search `include/path` 2. return matches on the
string prior to cursor *anywhere* in the resulting string. This is not how
vim's file-path-building `<C-X><C-F>` behaves which builds path's from the base
down. Instead this completion pulls back a smaller set of results, and can key
off the string values farther up the path.
