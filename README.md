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

This will map `<C-X><C-U>` to 
1. search `include/path` 
2. return matches on the
string prior to cursor *anywhere* in the resulting string. This is not how
vim's file-path-building `<C-X><C-F>` behaves which builds path's from the base
down. Instead this completion pulls back a smaller set of results, and can key
off the string values farther up the path.

# Credits/Inspiration

Currently I'm making heavy use of includes in ansible with variables in the
path. I have been using vim's file-building `<C-X><C-F>` and then adjusting the
path afterward. This is a fair amount of work. In the past I've done similar
things with PHP, and can see a general use case for this.

The original code was lifted from https://github.com/DavidRConnell/vimconfig/blob/master/autoload/latex.vim
who replied in a Reddit thread https://www.reddit.com/r/vim/comments/9bybpz/custom_omni_completion_for_inhouse_code_at_work/
I've generalized his code and modified the approach (use glob is faster then
expand and likewise map is faster then for loops).

Ingo Karkat has done much with completefunc (and much else) for example 
https://github.com/inkarkat/vim-CompleteHelper
But my use case here seems to have escaped his notice.
