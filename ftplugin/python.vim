setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=79
setlocal smarttab
setlocal expandtab
setlocal cc+=+1

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1
let s:keepcpo= &cpo
set cpo&vim

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.py
setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s

setlocal omnifunc=pythoncomplete#Complete

set wildignore+=*.pyc

nnoremap <silent> <buffer> ]] :<C-U>call <SID>Python_jump(0, 0, 1)<CR>
nnoremap <silent> <buffer> [[ :<C-U>call <SID>Python_jump(1, 0, 1)<CR>
nnoremap <silent> <buffer> ]m :<C-U>call <SID>Python_jump(0, 0, 0)<CR>
nnoremap <silent> <buffer> [m :<C-U>call <SID>Python_jump(1, 0, 0)<CR>

vnoremap <silent> <buffer> ]] :<C-U>call <SID>Python_jump(0, 1, 1)<CR>
vnoremap <silent> <buffer> [[ :<C-U>call <SID>Python_jump(1, 1, 1)<CR>
vnoremap <silent> <buffer> ]m :<C-U>call <SID>Python_jump(0, 1, 0)<CR>
vnoremap <silent> <buffer> [m :<C-U>call <SID>Python_jump(1, 1, 0)<CR>

onoremap <silent> <buffer> ]] :<C-U>execute 'normal ]][[V' . v:count1 . ']]'<CR>
onoremap <silent> <buffer> ]m :<C-U>execute 'normal ]m[mV' . v:count1 . ']m'<CR>

if !exists('*<SID>Python_jump')
    fun! <SID>Python_jump(back, visual, top)
        let n = v:count1
        let pattern = '^' . (a:top ? '' : '\s*') . '\(class\|def\)'
        if a:visual
            normal gv
            let pattern = '\n' . pattern
        endif
        let pattern = '\(\%^\|\%$\|' . pattern . '\)'
        mark '
        for _ in range(1, n)
            call search(pattern, 'W' . (a:back ? 'b' : ''))
        endfor
    endfun
endif

if has("browsefilter") && !exists("b:browsefilter")
    let b:browsefilter = "Python Files (*.py)\t*.py\n" .
                       \ "All Files (*.*)\t*.*\n"
endif

" As suggested by PEP8.
setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8

" First time: try finding "pydoc".
if !exists('g:pydoc_executable')
    let g:pydoc_executable = executable('pydoc') == 1
endif
" If "pydoc" was found use it for keywordprg.
if g:pydoc_executable
    setlocal keywordprg=pydoc
endif

let &cpo = s:keepcpo
unlet s:keepcpo
