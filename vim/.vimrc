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

""
"" Whitespace
""
set wrap linebreak nolist         " Wraps words when it reaches borders
set expandtab                     " use spaces, not tabs
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set backspace=indent,eol,start    " backspace through everything in insert mode

autocmd BufWritePre * :%s/\s\+$//e " Strips white spaces on save
