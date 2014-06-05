"Author: Carlos Pita

" <Leader>xt: select target window
map <silent> <Leader>xt :let b:targetwin = system("xdotool selectwindow")[:-2]<CR>
" <Leader>xw: eval current word
map <silent> <Leader>xw yiw:call <SID>EvalSel()<CR>
" <Leader>xx: eval current line
map <silent> <Leader>xx yy:call <SID>EvalSel()<CR>
" <Leader>xs: eval current visual selection
map <silent> <Leader>xs "+y:call <SID>EvalSel()<CR>
" <Leader>xc: eval region between prev <eval> and next </eval> markers
map <silent> <Leader>xc mS?<eval><CR>jy/^.*</eval><CR>`S:call <SID>EvalSel()<CR>
" <Leader>xr: eval region between x and y marks
map <silent> <Leader>xr mS`xy`y`S:call <SID>EvalSel()<CR>
" <Leader>xz: eval contents of unnamed register
map <silent> <Leader>xp :call <SID>EvalSel()<CR>
" <Leader>xf: eval entire file
map <silent> <Leader>xf <C-c>:call <SID>EvalFile()<CR>

let s:clipmax = 5

function s:EvalFile()
  let file = expand("%s")
  let nblines = 1 + prevnonblank(line("$")) - nextnonblank(1)
  let clipmax = exists("b:clipmax") ? b:clipmax : s:clipmax
  " If buffer has no file or is small enough treat it as a selection
  if empty(file) || nblines == 1 || (exists("b:clipcmd") && nblines <= clipmax)
    %yank
    call s:EvalSel()
  else
    write
    call s:Send(substitute(b:filecmd, "{FILE}", file, "g") . "\n", 1)
  endif
endfunction

function s:EvalSel(...)
  " If selection has just one non-blank line send it directly to target
  let oneline = matchstr(@", '^\(\s\|\n\)*\zs[^\n]\{-}\ze\(\s\|\n\)*$')
  if ! empty(oneline)
    call s:Send(oneline . "\n", 1)
    return
  endif
  " If selection has few (<= clipmax) non-blank lines use clipcmd if available
  if exists("b:clipcmd")
    let clipmax = exists("b:clipmax") ? b:clipmax : s:clipmax
    let cliplines = matchstr(@", '^\(\s\|\n\)*\zs\([^\n]\+\n\)\{2,' .
      \ clipmax . '}\ze\(\s\|\n\)*$')
    if ! empty(cliplines)
      let @* = cliplines
      call s:Send(substitute(b:clipcmd, "{WIN}", b:targetwin, "g"), 0)
      return
    endif
  endif
  " Otherwise send the selection as a tmp file using filecmd
  if ! exists("b:tmpfile") | let b:tmpfile = tempname() | endif
  execute "redir! > " . b:tmpfile | echo @" | redir END
  call s:Send(substitute(b:filecmd, "{FILE}", b:tmpfile, "g") . "\n", 1)
endfunction

function s:Send(cmd, type)
  " :!... will expand !, %, # and <cword> in ... if unescaped, also \n will end
  " ... if unescaped (see :h :! and :h shellescape())
  let cmd = ! a:type ? a:cmd :
    \ "type --delay 0 --window " . b:targetwin .  " " . shellescape(a:cmd, 1)
  execute "silent !xdotool " . cmd . " >/dev/null 2>&1 &"
  redraw!
endfunction
