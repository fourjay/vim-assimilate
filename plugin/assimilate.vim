" setup known state
if exists('did_assimilate') 
      "  || &compatible 
      "  || version < 700}
    finish
endif
let g:did_assimilate = '1'
let s:save_cpo = &cpoptions
set compatible&vim

" manage settings
let s:defaults = {
            \ 'keep_whole_path': 0,
            \ 'trim_include': 1,
            \ 'keep_suffixes': 0
            \ }

" create attay if user has not defined
if ! exists('g:assimilate_settings')
    let g:assimilate_settings = {}
endif

" populate with defaults if not set by user
for s:key in keys(s:defaults)
    if ! has_key( g:assimilate_settings, s:key )
        let g:assimilate_settings[s:key] = s:defaults[s:key]
    endif
endfor

" Return vim to users choice
let &cpoptions = s:save_cpo
echo g:assimilate_settings
