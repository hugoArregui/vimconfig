" Environment {
      " Basics {
                let mapleader = ","
                set nocompatible
      " }

      " Extensions {
                filetype off
                set rtp+=~/.vim/bundle/Vundle.vim
                call vundle#begin()

                Plugin 'gmarik/vundle'
                Plugin 'L9'
                Plugin 'majutsushi/tagbar'
                Plugin 'LargeFile'
                Plugin 'matchit.zip'
                Plugin 'Tabular'
                Plugin 'camelcasemotion'
                Plugin 'rainbow_parentheses.vim'
                Plugin 'tpope/vim-abolish'
                Plugin 'tpope/vim-fugitive'
                Plugin 'tpope/vim-unimpaired'
                Plugin 'tpope/vim-vinegar'
                Plugin 'tpope/vim-commentary'
                Plugin 'tpope/vim-markdown'
                Plugin 'tpope/vim-surround'
                Plugin 'tpope/vim-repeat'
                Plugin 'nelstrom/vim-markdown-folding'
                Plugin 'nelstrom/vim-docopen'
                Plugin 'gregsexton/gitv'
                Plugin 'mattn/webapi-vim'
                Plugin 'mattn/gist-vim'
                Plugin 'michaeljsmith/vim-indent-object'
                Plugin 'kana/vim-textobj-user'
                Plugin 'kana/vim-textobj-function'
                Plugin 'bps/vim-textobj-python'
                Plugin 'jamessan/vim-gnupg'
                Plugin 'SirVer/ultisnips'
                Plugin 'vim-pandoc/vim-pandoc-syntax'
                Plugin 'vim-pandoc/vim-pandoc'
                Plugin 'vim-scripts/DetectIndent'
                Plugin 'gnu-c'
                Plugin 'hynek/vim-python-pep8-indent'
                Plugin 'vitalk/vim-shebang'
                Plugin 'pangloss/vim-javascript'
                Plugin 'ctrlpvim/ctrlp.vim'


                call vundle#end()
                filetype indent plugin on    " Enable filetype-specific plugins
                syntax on

                let g:gist_post_private = 1

                set hidden 
                set runtimepath+="~/.vim/UltiSnips"
                let tagbar_compact=1
                let tagbar_sort=0                " Don't sort alphabetically tagbar's list, show it in the defined order
                let g:UltiSnipsExpandTrigger="<tab>"
                let g:ctrlp_custom_ignore = {
                      \ 'dir':  '\v[\/]\.(git|hg|svn)$',
                      \ 'file': '\v\.(pyc|so|class|o)$',
                      \ 'link': 'some_bad_symbolic_links',
                      \ }
      " }
" }

" Functions {
      augroup line_return                        " Make sure Vim returns to the same line when you reopen a file.
          au!
          au BufReadPost *
              \ if line("'\"") > 0 && line("'\"") <= line("$") |
              \     execute 'normal! g`"zvzz' |
              \ endif
      augroup END

      function! s:VSetSearch()                    " Visual Mode */# from Scrooloose
        let temp = @@
        norm! gvy
        let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
        let @@ = temp
      endfunction

      function! <SID>SynStack()                   " Show syntax highlighting groups for word under cursor
        if !exists("*synstack")
          return
        endif
        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
      endfunc
" }

" General {
      "set nobackup
      set undodir=~/tmp/vim/undo/     " undo files
      set backupdir=~/tmp/vim/backup/ " backups
      set directory=~/tmp/vim/swap/   " swap files

      set wildmenu
      set wildmode=list:longest,full  

      set ttyfast
      set encoding=utf-8
      set undofile
      set cursorline

      set tabpagemax=100
      set copyindent
      set cinoptions=>4
      set hlsearch

      if has('gui_running')
        colorscheme github
        set guioptions=
      else
        set t_Co=256
        colorscheme jellybeans
      endif

      set showcmd                  " show partial command in status line
      set showmatch                " show matching brackets
      set ruler                    " show ruler (line & column numbers)
      set relativenumber
      set number

      set laststatus=2
      set statusline=%{fugitive#statusline()}\ >>\ %f\ %m\ (%l/%L)
      "au BufWinLeave * silent! mkview
      "au BufWinEnter * silent! loadview
" }

" Formatting {
      set lispwords+=let-values,condition-case,with-input-from-string
      set lispwords+=with-output-to-string,handle-exceptions,call/cc,rec,receive
      set lispwords+=call-with-output-file,define-for-syntax,define-foreign-record-type
      set lispwords+=define-concurrent-native-callback,define-synchronous-concurrent-native-callback
      set lispwords+=define-callback,test-group,define-target,define-page
      set lispwords+=let-local-refs,define-class
      set autoindent		
      set backspace=2 
      set expandtab
      set tabstop=2       " spaces that a <Tab> in the file counts for.
      set softtabstop=2   " spaces that a <Tab> counts for while editing.
      set shiftwidth=2    " spaces to use for each step of (auto)indent.
      if has("autocmd")
            autocmd FileType apache setl commentstring=#\ %s
            autocmd FileType java setl tabstop=4|setl shiftwidth=4|setl softtabstop=4|setl expandtab
            autocmd FileType c setl tabstop=4|setl shiftwidth=4|setl softtabstop=4|setl expandtab
            autocmd FileType cpp setl tabstop=4|setl shiftwidth=4|setl softtabstop=4|setl expandtab
            autocmd FileType javascript setl tabstop=2|setl shiftwidth=2|setl softtabstop=2|setl expandtab
            autocmd FileType make setl noexpandtab
            autocmd FileType scheme RainbowParenthesesLoadRound
            autocmd FileType scheme setl iskeyword=33,35-36,38,42-58,60-90,94,95,97-122,126,_,+,-,*,/,<,=,>,:,$,?,!,@-@,#
            autocmd FileType scheme :DetectIndent
            autocmd FileType clojure setl tabstop=2|setl shiftwidth=2|setl softtabstop=0|setl expandtab
            autocmd FileType mail setl textwidth=70|setl fo+=aw
            autocmd BufReadCmd *.epub call zip#Browse(expand("<amatch>"))
            autocmd BufRead,BufNewFile *.md setl filetype=markdown
            autocmd BufRead,BufNewFile *.tsv setl noexpandtab|setl shiftwidth=20|setl softtabstop=20|setl tabstop=20|setl nowrap
            autocmd FileType * RainbowParenthesesToggle
            autocmd FileType * let &keywordprg = 'kvim ' . &filetype
      endif

      " Set some sensible defaults for editing C-files
      augroup cprog
        " Remove all cprog autocommands
        au!

        " When starting to edit a file:
        "   For *.c and *.h files set formatting of comments and set C-indenting on.
        "   For other files switch it off.
        "   Don't change the order, it's important that the line with * comes first.
        autocmd BufRead *       setl formatoptions=tcql nocindent comments&
        autocmd BufRead *.c,*.h setl formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
      augroup END

      "better linewraps
      " set showbreak=↪
" }

" Spell Check {
  let b:myLang=0
  let g:myLangList=["nospell","es","en"]
  function! ToggleSpell()
    let b:myLang=b:myLang+1
    if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
    if b:myLang==0
      setlocal nospell
    else
      execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
    endif
    echo "spell checking language:" g:myLangList[b:myLang]
  endfunction

  nmap <silent> <F7> :call ToggleSpell()<CR>
  nmap <silent> <F8> vip :!sort<CR>
  autocmd FileType mail redraw|:call ToggleSpell()
" }

" Bindings {
      map <tab> %
      nnoremap <silent> <F4> :TagbarToggle<CR><C-W><C-W>

      nmap <silent> <leader>h :silent :nohlsearch<CR> 
      nmap <silent> <leader>s :set nolist!<CR>

      noremap H ^
      noremap L $
      vnoremap L g_
      nnoremap j gj
      nnoremap k gk

      map <leader>p "+p " Paste from OS clipboard
      map <leader>y "+y " Copy to OS clipboard
      map <leader>x "*y " Copy to X clipboard

      "visual search
      vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR><c-o>
      vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR><c-o> 

      " Show syntax highlighting groups for word under cursor
      nmap <C-S-P> :call <SID>SynStack()<CR>
      inoremap jj <Esc>

      set showmode

      "search regexp
      nnoremap <leader>/ :%s/\v/g<Left><Left>
      vnoremap <leader>/ :s/\v/g<Left><Left>

      :com StripWhitespace  %s/\s\+$//e

      " Training {
            nnoremap <up> <nop>
            nnoremap <down> <nop>
            nnoremap <left> <nop>
            nnoremap <right> <nop>
            nnoremap <PageUp> <nop>
            nnoremap <PageDown> <nop>
            inoremap <Esc> <nop>
      " }

" }

" allow override vimrc {
		set exrc " from http://www.ilker.de/specific-vim-settings-per-project.html
		set secure
" }
