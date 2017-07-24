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
"" Appearance
""
color smyck

""
"" Whitespace
""
set wrap linebreak nolist         " Wraps words when it reaches borders
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode

autocmd BufWritePre * :%s/\s\+$//e " Strips white spaces on save


