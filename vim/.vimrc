""
"" Plugins
""
call plug#begin('~/.vim/plugins')
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline' " very useful fixed bar
Plug 'terryma/vim-multiple-cursors' " multiple cursor edition
Plug 'brendonrapp/smyck-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim' " fuzzyfinder plugin for vim
Plug 'neomake/neomake' " allow me to run linters and etc after saving a file
Plug 'ervandew/supertab' " allow me to use tab for evereything
Plug 'scrooloose/nerdtree'
Plug 'docteurklein/vim-symfony' " very useful for php + symfony
Plug 'stanangeloff/php.vim'
call plug#end()


""
"" Variables
""
let mapleader = "-"


" nerdtree
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 0
let NERDTreeChDirMode = 1
let NERDTreeDirArrowExpandable = '+'
let NERDTreeDirArrowCollapsible = '~'

" jslint
let g:neomake_javascript_jshint_maker = {
      \ 'args': ['--verbose'],
      \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
      \ }


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
set ignorecase

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
nnoremap <C-e> :NERDTreeToggle<cr>
nnoremap <C-f> :NERDTreeFind<cr>

""
"" Commands
""
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufWritePre * :%s/\s\+$//e " strips white spaces on save

" languagues
autocmd FileType * set tabstop=2|set shiftwidth=2
autocmd FileType php set tabstop=4|set shiftwidth=4
autocmd FileType python set tabstop=4|set shiftwidth=4
autocmd FileType ruby set tabstop=2|set shiftwidth=2
autocmd FileType xml set tabstop=4|set shiftwidth=4

" neomake
autocmd! BufReadPost,BufWritePost * Neomake

" php.vim
function! PhpSyntaxOverride()
  hi! def link phpDocTags  phpDefine
  hi! def link phpDocParam phpType
endfunction

augroup phpSyntaxOverride
  autocmd!
  autocmd FileType php call PhpSyntaxOverride()
augroup END
