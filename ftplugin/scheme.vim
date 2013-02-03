let g:is_chicken=1
nmap &lt;silent&gt; == :call Scheme_indent_top_sexp()&lt;cr&gt;

" Indent a toplevel sexp.
fun! Scheme_indent_top_sexp()
  let pos = getpos('.')
  silent! exec "normal! 99[(=%"
  call setpos('.', pos)
endfun
