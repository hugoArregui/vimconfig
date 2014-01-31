" <Leader>xw: select target window
map <silent> <Leader>xw :let b:targetwin = system("xdotool selectwindow")[:-2]<CR>
" <Leader>xx: eval current line
map <silent> <Leader>xx yy:call <SID>Eval()<CR>
" <Leader>xs: eval current visual selection
map <silent> <Leader>xs y:call <SID>Eval()<CR>
" <Leader>xc: eval region between prev <eval> and next </eval> markers
map <silent> <Leader>xc mS?<eval><CR>jy/^.*</eval><CR>`S:call <SID>Eval()<CR>
" <Leader>xr: eval region between x and y marks
map <silent> <Leader>xr mS`xy`y`S:call <SID>Eval()<CR>
" <Leader>xz: eval contents of unnamed register
map <silent> <Leader>xp :call <SID>Eval()<CR>
" <Leader>xf: eval entire file
map <silent> <Leader>xf :call <SID>Eval(1)<CR>

function s:Eval(...)
  if ! exists("b:targetwin") | throw "Undefined b:targetwin" | endif
  let file = "" | let mlist = []
  if a:0 > 0 && a:1 " entire file must be evaluated
    let file = expand("%")
    if empty(file) | %yank | else | write | endif
  endif
  if empty(file) " selection must be evaluated, check for a onliner
    let mlist = matchlist(@", "^\\s*\\([^\n]*\\)\n*$")
  endif
  if len(mlist) " case 1: oneliner
    let text = mlist[1]
  elseif ! empty(file) || ! exists("b:evalsel") " case 2: entire|tmp file
    if ! exists("b:evalfile") | throw "Undefined b:evalfile" | endif
    if empty(file) " no b:evalsel && no entire file -> copy sel to tmp file
      if ! exists("b:tmpfile") | let b:tmpfile = tempname() | endif
      execute "redir! > " . b:tmpfile | echo @" | redir END
      let file = b:tmpfile
    endif
    let text = substitute(b:evalfile, "{FILE}", file, "g")
  else " case 3: directly paste sel
    let @+ = @" | let @* = @" " copy unnamed to clipboard & primary sel
    let text = b:evalsel
  endif
  " :!{cmd} will expand !, %, # and <cword> in {cmd} if unescaped, also \n will
  " end {cmd} in unescaped (see :h :! and :h shellescape())
  execute "silent !xdotool type --delay 0 --window " . b:targetwin .
          \ " " . shellescape(text . "\n", 1) . " >/dev/null 2>&1 &"
  redraw!
endfunction
