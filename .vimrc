"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file is use.
filetype indent on
filetype on

" Enable plugins and load plugin for the detected file type.
call pathogen#helptags()
execute pathogen#infect("bundle/{}", "~/vim_env/plugins/{}")
syntax on
filetype plugin indent on

" Load an indent file for the detected file type.

" Add numbers to the file.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Set shift width to 2 spaces.
set shiftwidth=2

" Set tab width to 2 columns.
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
"au BufReadPost *.conf set syntax=ini

set guioptions+=a
set foldmethod=syntax

" }}}
" MAPPINGS --------------------------------------------------------------- {{{

" Set the backslash as the leader key.

" Press \\ to jump back to the last cursor position.
nnoremap <leader>\ ``

" Press \p to print the current file to the default printer from a Linux operating system.
" View available printers:   lpstat -v
" Set default printer:       lpoptions -d <printer_name>
" <silent> means do not display output.
nnoremap <silent> <leader>p :%w !lp<CR>

" Type jj to exit insert mode quickly.
inoremap jj <Esc>

" Press the space bar to type the : character in command mode.
nnoremap <space> :

" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below the current line.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
nnoremap Y y$

" Map the F5 key to run a Python script inside Vim.
" We map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
nnoremap <c-up> <c-w>+
nnoremap <c-down> <c-w>-
nnoremap <c-left> <c-w>>
nnoremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the F3 key to toggle NERDTree open and close.
nnoremap <F3> :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" Enable the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab
" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" Reverse the lines of the whole file or a visually highlighted block.
    " :Rev is a shorter prefix you can use.
    " Adapted from http://tech.groups.yahoo.com/group/vim/message/34305
command! -nargs=0 -bar -range=% Reverse
    \       let save_mark_t = getpos("'t")
    \<bar>      <line2>kt
    \<bar>      exe "<line1>,<line2>g/^/m't"
    \<bar>  call setpos("'t", save_mark_t)

nmap <Leader>r :Reverse<CR>
xmap <Leader>r :Reverse<CR>


noremap <leader>w :call DeleteTrailingWS()<CR>
function! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunction

autocmd BufWrite *.v,*.sv :call DeleteTrailingWS()

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline and cursorcolumn ONLY in active window.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END


noremap <F6> :call ToggleMouse()<CR>
function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Mouse usage disabled" 
  else 
    set mouse=a
    echo "Mouse usage enabled" 
  endif
endfunction

" If GUI version of Vim is running set these options.

    " Set the background tone.
set background=dark

    " Set the color scheme.
colorscheme   gruvbox " blue  molokai

    " Set a custom font you have installed on your computer.
    " Syntax: <font_name>\ <weight>\ <size>
    set guifont=Monospace\ Regular\ 12

    " Display more of the file by default.
    " Hide the toolbar.
set guioptions-=T

    " Hide the the left-side scroll bar.
set guioptions-=L

    " Hide the the left-side scroll bar.
set guioptions-=r

    " Hide the the menu bar.
set guioptions-=m

    " Hide the the bottom scroll bar.
set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
    \set guioptions-=mTr<Bar>
    \else<Bar>
    \set guioptions+=mTr<Bar>
    \endif<CR>


" }}}

" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
set cursorcolumn
set noerrorbells
set t_vb=
"set bs=indent,eol,start

let g:indentLine_faster=1
let g:indentLine_newVersion=0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

let g:gruvbox_contrast_dark="soft"
let g:gruvbox_hls_cursor="orange"
let g:airline#extensions#tabline#formatter='default'
let g:airline#extensions#tabline#left_sep=' '
let g:airline#extensions#tabline#left_alt_sep='|'
let g:airline#extensions#tabline#formatter='jsformatter'
let g:airline_theme='base16_gruvbox_dark_soft'

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#show_splits=0
let g:airline#extensions#tabline#show_tabs=1
let g:airline#extensions#tabline#show_tab_nr=0
let g:airline#extensions#tabline#show_tab_type=0
let g:airline#extensions#tabline#close_symbol='*'
let g:airline#extensions#tabline#close_button=0
let g:airline#extensions#wordcount#enabled=0

if v:version > 704
  set runtimepath+= "~/vim_env/plugins/anguageClient-neovim"
  let g:LanguageClient_serverCommands = {
    \ 'verilog_systemverilog': ['svls'],
    \ 'systemverilog': ['svls'],
    \ 'verilog': ['svls'],
    \ }
endif  

