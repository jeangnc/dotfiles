  ""
"" Plugins
""
call plug#begin('~/.vim/plugins')
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'brendonrapp/smyck-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim' " fuzzyfinder plugin for vim
Plug 'vim-airline/vim-airline' " very useful fixed bar
Plug 'neomake/neomake' " allow me to run linters and etc after saving a file
Plug 'terryma/vim-multiple-cursors' " multiple cursor edition
Plug 'ervandew/supertab' " allow me to use tab for evereything
Plug 'docteurklein/vim-symfony' " very useful for php + symfony
call plug#end()


""
"" Variables
""
let mapleader = "-"

" neomake
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

" netrw
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_list_hide = &wildignore
let g:netrw_altv = 1
let g:netrw_keepdir=0

""
"" Basic configuration
""
set hidden
set number
set cursorline
set ruler
set splitbelow               " open new splits below
set splitright               " open new splits at the right
set switchbuf=usetab
set colorcolumn=100
set encoding=utf-8
set langmenu=en_US.UTF-8
set nocompatible      " we're running Vim, not Vi!

" wildmenu
set wildmenu
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem,*.log,*.cache
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*/tmp/librarian/*,*/.vagrant/*,*/.kitchen/*,*/vendor/cookbooks/*
set wildignore+=*/tmp/cache/assets/*/sprockets/*,*/tmp/cache/assets/*/sass/*
set wildignore+=*.swp,*~,._*

" whitespace
set nowrap                        " break line after it reachs the limit
set expandtab                     " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode

""
"" Commands
""
autocmd FileType * set tabstop=2|set shiftwidth=2
autocmd FileType php set tabstop=4|set shiftwidth=4
autocmd FileType ruby set tabstop=2|set shiftwidth=2
autocmd FileType python set tabstop=4|set shiftwidth=4
autocmd FileType xml set tabstop=4|set shiftwidth=4
autocmd BufWritePre * :%s/\s\+$//e " strips white spaces on save
autocmd! BufReadPost,BufWritePost * Neomake " neomake

""
"" Appearance
""
color smyck

""
"" Languages
""
syntax on             " enable syntax highlighting
filetype on           " enable filetype detection
filetype indent on    " enable filetype-specific indenting
filetype plugin on    " enable filetype-specific plugins

""
"" Keymapping
""
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>sh :History:<cr>

" buffers
nnoremap <leader><backspace> :bd<CR>
nnoremap <F8> :bnext<CR>
nnoremap <S-F8> :bprevious<CR>
nnoremap <C-left> :tabp<cr>
nnoremap <C-right> :tabn<cr>
nnoremap <C-e> :Vex<cr>

