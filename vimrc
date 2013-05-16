" Environment {
      " Basics {
                let mapleader = ","
                set nocompatible
      " }

      " Extensions {
                filetype off
                set rtp+=~/.vim/bundle/vundle/
                call vundle#rc()
                syntax on

                Bundle 'gmarik/vundle'
                Bundle 'L9'
                Bundle 'FuzzyFinder'
                Bundle 'scrooloose/nerdcommenter'
                Bundle 'scrooloose/nerdtree'
                Bundle 'majutsushi/tagbar'
                Bundle 'LargeFile'
                Bundle 'matchit.zip'
                Bundle 'Tabular'
                Bundle 'camelcasemotion'
                Bundle 'tpope/vim-markdown'
                Bundle 'myusuf3/numbers.vim'
                Bundle 'rainbow_parentheses.vim'
                "Bundle 'ultisnips'              " handle by pacman, vundle doesn't work for some reason

                set runtimepath+="~/.vim/UltiSnips"
                let NERDTreeShowBookmarks=1
                let tagbar_compact=1
                let tagbar_sort=0                " Don't sort alphabetically tagbar's list, show it in the defined order
                let g:fuf_modesDisable = []
                let g:fuf_mrufile_maxItem = 400
                let g:fuf_mrucmd_maxItem = 400
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
      set nobackup
      set undodir=~/tmp/vim/undo//     " undo files
      set backupdir=~/tmp/vim/backup// " backups
      set directory=~/tmp/vim/swap//   " swap files

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

      set t_Co=256
      colorscheme jellybeans

      set showcmd                  " show partial command in status line
      set showmatch                " show matching brackets
      set ruler                    " show ruler (line & column numbers)
      filetype indent plugin on    " Enable filetype-specific plugins
" }

" Formatting {
      setl lispwords+=let-values,condition-case,with-input-from-string
      setl lispwords+=with-output-to-string,handle-exceptions,call/cc,rec,receive
      setl lispwords+=call-with-output-file,define-for-syntax,define-foreign-record-type
      setl lispwords+=define-concurrent-native-callback,define-synchronous-concurrent-native-callback
      setl lispwords+=define-callback
      set autoindent		
      set backspace=2 
      set ts=2
      set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab

      if has("autocmd")
            au BufRead,BufNewFile SConscript set filetype=python
            autocmd FileType python set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
            autocmd FileType c set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
            autocmd FileType cpp set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
            autocmd FileType make set noexpandtab
            au VimEnter * RainbowParenthesesToggle
            autocmd FileType scheme RainbowParenthesesLoadRound
      endif

      " Set some sensible defaults for editing C-files
      augroup cprog
        " Remove all cprog autocommands
        au!

        " When starting to edit a file:
        "   For *.c and *.h files set formatting of comments and set C-indenting on.
        "   For other files switch it off.
        "   Don't change the order, it's important that the line with * comes first.
        autocmd BufRead *       set formatoptions=tcql nocindent comments&
        autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
      augroup END
" }

" Bindings {
      map <tab> %
      map <F2> :NERDTreeToggle<CR>
      nnoremap <silent> <F4> :TagbarToggle<CR><C-W><C-W>

      nmap <silent> <leader>h :silent :nohlsearch<CR> 
      nmap <silent> <leader>s :set nolist!<CR>

      nmap <leader>F :FufFile<CR>
      nmap <leader>f :FufCoverageFile<CR>
      nmap <leader>v :FufBuffer<CR>

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

      nnoremap <F3> :set invpaste paste?<CR>
      set pastetoggle=<F3>
      set showmode

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
