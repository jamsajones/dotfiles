call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

" wp.com style guide for ruby tabs
" use this as default, perl-support will override
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    set et

" DRS customization
    set laststatus=2
" comment and uncomment
  map \# :s/^/# /<CR> :noh<CR>
  map \* :s/^ *# \?//<CR> :noh<CR>

"
"===============================================================================
"==========  load example vimrc from the distribution  =========================
"===============================================================================
"
runtime vimrc_example.vim
"
"===============================================================================
"==========  CUSTOMIZATION (vimrc)  ============================================
"===============================================================================
"
" Backupdir
    set backupdir =$HOME/.vim.backupdir
"
"-------------------------------------------------------------------------------
" Use of dictionaries
"-------------------------------------------------------------------------------
"
set complete+=k           " scan the files given with the 'dictionary' option
"
"-------------------------------------------------------------------------------
" Various settings
"-------------------------------------------------------------------------------
"
"set autoread              " read open files again when changed outside Vim
"set autowrite             " write a modified buffer on each :next , ...
set browsedir  =current   " which directory to use for the file browser
set incsearch             " use incremental search
set nowrap                " do not wrap lines
set shiftwidth =2         " number of spaces to use for each step of indent
set tabstop    =4         " number of spaces that a <Tab> in the file counts for
set visualbell            " visual bell instead of beeping
"
"
"-------------------------------------------------------------------------------
"  some additional hot keys
"-------------------------------------------------------------------------------
"    F2   -  write file without confirmation
"    F3   -  call file explorer Ex
"    F4   -  show tag under curser in the preview window (tagfile must exist!)
"    F6   -  list all errors           
"    F7   -  display previous error
"    F8   -  display next error   
"    F12  -  toggle line numbers
"  S-Tab  -  Fast switching between buffers (see below)
"    C-q  -  Leave the editor with Ctrl-q (see below)
"-------------------------------------------------------------------------------
"
map   <silent> <>    :write<CR>
map   <silent> <F3>    :Explore<CR>
nmap  <silent> <F4>    :exe ":ptag ".expand("<cword>")<CR>
map   <silent> <F6>    :copen<CR>
map   <silent> <F7>    :cp<CR>
map   <silent> <F8>    :cn<CR>
map   <silent> <F12>   :let &number=1-&number<CR>
"
imap  <silent> <F2>    <Esc>:write<CR>
imap  <silent> <F3>    <Esc>:Explore<CR>
imap  <silent> <F4>    <Esc>:exe ":ptag ".expand("<cword>")<CR>
imap  <silent> <F6>    <Esc>:copen<CR>
imap  <silent> <F7>    <Esc>:cp<CR>
imap  <silent> <F8>    <Esc>:cn<CR>
imap  <silent> <F12>   :let &number=1-&number<CR>
"
" autocomplete brackets and braces
" 
imap ( ()<Left>
imap [ []<Left>
imap { {}<Left>
"
"-------------------------------------------------------------------------------
" Fast switching between buffers
" The current buffer will be saved before switching to the next one.
" Choose :bprevious or :bnext
"-------------------------------------------------------------------------------
"
 map  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bnext<CR>
imap  <silent> <s-tab>  <Esc>:if &modifiable && !&readonly && 
     \                  &modified <CR> :write<CR> :endif<CR>:bnext<CR>
"
"-------------------------------------------------------------------------------
" Leave the editor with Ctrl-q : Write all changed buffers and exit Vim
"-------------------------------------------------------------------------------
nmap  <C-q>    :wqa<CR>
"
"-------------------------------------------------------------------------------
" Change the working directory to the directory containing the current file
"-------------------------------------------------------------------------------
if has("autocmd")
  autocmd BufEnter * :lcd %:p:h
endif " has("autocmd")
"
"-------------------------------------------------------------------------------
" Filename completion
" 
"   wildmenu : command-line completion operates in an enhanced mode
" wildignore : A file that matches with one of these
"              patterns is ignored when completing file or directory names.
"-------------------------------------------------------------------------------
" 
set wildmenu
set wildignore=*.bak,*.o,*.e,*~
"
"-------------------------------------------------------------------------------
" print options  (pc = percentage of the media size)
"-------------------------------------------------------------------------------
set printoptions=left:8pc,right:3pc

"-------------------------------------------------------------------------------
" NerdTree.vim
"-------------------------------------------------------------------------------
:map <C-d> :execute 'NERDTreeToggle ' .getcwd()<CR>

"-------------------------------------------------------------------------------
" VCSCommand.vim
"-------------------------------------------------------------------------------
:map <C-x> :execute 'VCSVimDiff'<CR>

"-------------------------------------------------------------------------------
" Show tabs vs spaces
"-------------------------------------------------------------------------------
set list listchars=tab:>-,trail:.
:highlight SpecialKey ctermbg=red

function! SplitConflict ()
    let l:bufferFileType = &filetype "get current filetype
    vnew
    read#
    0d
    let &filetype = l:bufferFileType "set filetype in new buffer to filetype of the old buffer
    " run deletions in the Left window
    call DeleteLeft()
    wincmd w
    " repeat deletions but in the opposite direction
    call DeleteRight()
    " turn on diff mode for this window
    diffthis
    "switch to the other window
    wincmd p
    "and turn on diffs there
    diffthis
endfunction

function! DeleteLeft()
    " Left: remove
    "   =======
    "   ...
    "   >>>>>>>
    " sections, and remove the <<<<<<< line
    silent g/^=======/.;/^>>>>>>>/d
    silent g/^<<<<<<</d
    set nomod
    normal gg
endfunction

function! DeleteRight()
    " Right: remove
    "   >>>>>>>
    "   ...
    "   =======
    " sections, and remove the <<<<<<< line
    wincmd l
    silent g/^<<<<<<</.;/^=======/d
    silent g/^>>>>>>>/d
    set nomod
    normal gg
endfunction


let NERDTreeDirArrows=0
