let mapleader = ","
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
syntax on

" let Vundle manage Vundle
" required for vundle
Bundle 'gmarik/vundle'

Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
Bundle 'LargeFile'

set wildmenu
set wildmode=list:longest,full  

" Paste from OS clipboard
map <leader>p "+p
" Copy to OS clipboard
map <leader>y "+y

set ttyfast
set encoding=utf-8
set undofile
set cursorline

set tabpagemax=100
set backspace=2 
set ts=2
set autoindent		
set copyindent
set cinoptions=>4
set hlsearch

"colorscheme desert
set t_Co=256
"colorscheme  calmar256-dark
colorscheme jellybeans

" show partial command in status line
set showcmd
" show matching brackets
set showmatch
" show ruler (line & column numbers)
set ruler
set nobackup

" i hate cyan comments :)
hi Comment ctermfg=DarkGrey guifg=DarkGrey

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

vmap <silent> <Leader>i= <ESC>:AlignPush<CR>:AlignCtrl lp1P1<CR>:'<,'>Align=<CR>:AlignPop<CR>
vmap <silent> <Leader>i, <ESC>:AlignPush<CR>:AlignCtrl lp0P1<CR>:'<,'>Align,<CR>:AlignPop<CR>
vmap <silent> <Leader>i( <ESC>:AlignPush<CR>:AlignCtrl lp0P0<CR>:'<,'>Align(<CR>:AlignPop<CR>

set tabstop=2|set shiftwidth=2|set softtabstop=2|set expandtab
au BufRead,BufNewFile SConscript set filetype=python
autocmd FileType python set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
autocmd FileType c set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
autocmd FileType cpp set tabstop=4|set shiftwidth=4|set softtabstop=4|set expandtab
autocmd FileType make set noexpandtab


if has("autocmd")

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

" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPre,FileReadPre	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 |'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost      *.bz2 execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END


"leer pdf
autocmd BufReadPre *.pdf set ro nowrap
autocmd BufReadPost *.pdf silent %!pdftotext "%" -layout -q -eol unix -
autocmd BufWritePost *.pdf silent !rm -rf ~/PDF/%
autocmd BufWritePost *.pdf silent !lp -s -d "%"
autocmd BufWritePost *.pdf silent !until [ -e ~/PDF/% ]; do sleep 1; done
autocmd BufWritePost *.pdf silent !mv ~/PDF/% %:p:h

endif   "has ("autocmd")

"NERD Tree
map <F2> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1

" --------------------
" TagBar
" --------------------
let tagbar_compact=1
" Don't sort alphabetically tagbar's list, show it in the defined order
let tagbar_sort=0
nnoremap <silent> <F4> :TagbarToggle<CR><C-W><C-W>


" FuzzyFinder config
let g:fuf_modesDisable = []
let g:fuf_mrufile_maxItem = 400
let g:fuf_mrucmd_maxItem = 400

" Shortcuts
nmap <silent> <leader>h :silent :nohlsearch<CR>
nmap <silent> <leader>s :set nolist!<CR>
nmap <leader>F :FufFile<CR>
nmap <leader>f :FufCoverageFile<CR>
nmap <leader>b :FufBuffer<CR>

"disable keys
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
