  ""
"" Plugins
""
call plug#begin('~/.vim/plugins')

Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'brendonrapp/smyck-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'neomake/neomake'

call plug#end()


""
"" Vars
""
let mapleader = "-"

let g:netrw_browse_split = 2
let g:netrw_banner = 0

""
"" Keymapping
""

" others
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>h :History<cr>

" buffers
noremap <F8> :sbnext<CR>
nnoremap <S-F8> :sbprevious<CR>
nnoremap <C-Left> :tabp<cr>
nnoremap <C-right> :tabn<cr>

""
"" Basic
""
set hidden
set number
set cursorline
set ruler
set splitbelow "open new splits below
set splitright "open new splits at the right
set switchbuf=usetab
set colorcolumn=100
set encoding=utf-8
set langmenu=en_US.UTF-8

""
"" Languages
""
set nocompatible      " We're running Vim, not Vi!
syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

""
"" Wildmenu
""
set wildmenu
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem,*.log,*.cache
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*.swp,*~,._*

""
"" Neomake
""
autocmd! BufReadPost,BufWritePost * Neomake

let g:neomake_error_sign = { 'text': '✖', 'texthl': 'NeomakeErrorSign' }
let g:neomake_warning_sign = { 'text': '⚠', 'texthl': 'NeomakeWarningSign' }
let g:neomake_message_sign = { 'text': '➤', 'texthl': 'NeomakeMessageSign' }
let g:neomake_info_sign = { 'text': 'ℹ', 'texthl': 'NeomakeInfoSign' }

" jslint
let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ }
let g:neomake_javascript_enabled_makers = ['jshint']

""
"" Appearance
""
color smyck

""
"" Whitespace
""
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set backspace=indent,eol,start    " backspace through everything in insert mode
set expandtab                     " use spaces, not tabs
set wrap

autocmd BufWritePre * :%s/\s\+$//e " Strips white spaces on save
