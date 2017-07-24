""
"" Plugins
""
call plug#begin('~/.vim/plugins')

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'

" appearance
Plug 'brendonrapp/smyck-vim'

call plug#end()


""
"" Basic
""
set number
set cursorline
set colorcolumn=100
set encoding=utf-8
set ruler

""
"" Languages
""
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

""
"" Appearance
""
color smyck

" netrw
let g:netrw_browse_split = 2
let g:netrw_banner = 0

""
"" Whitespace
""
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set backspace=indent,eol,start    " backspace through everything in insert mode
set expandtab                     " use spaces, not tabs
set nowrap

autocmd BufWritePre * :%s/\s\+$//e " Strips white spaces on save
