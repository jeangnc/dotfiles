""
"" Plugins
""
call plug#begin('~/.vim/plugins')

Plug 'scrooloose/nerdtree' " filesystem explorer
Plug 'vim-airline/vim-airline' " very useful fixed bar
Plug 'jeetsukumaran/vim-indentwise' " indent based motions
Plug 'christoomey/vim-tmux-navigator'
Plug 'dkarter/bullets.vim'
Plug 'github/copilot.vim'

"" go
Plug 'fatih/vim-go'

"" clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'

" other languages
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " fuzzyfinder plugin for vim

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" colorschemes
Plug 'brendonrapp/smyck-vim'

call plug#end()


""
"" Variables
""
let mapleader = "-"

" nerdtree
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeChDirMode = 1
let NERDTreeDirArrowCollapsible = '-'
let NERDTreeDirArrowExpandable = '+'
let NERDTreeDirArrows = 1
let NERDTreeMapOpenInTab = '<C-t>'
let NERDTreeMapOpenSplit = '<C-h>'
let NERDTreeMapOpenVSplit = '<C-v>'
let NERDTreeMinimalMenu = 1
let NERDTreeMinimalUI = 1
let NERDTreeQuitOnOpen = 1
let NERDTreeShowHidden = 1
let NERDTreeWinSize = 40
let NERDTreeCascadeSingleChildDir = 1
let NERDTreeCascadeOpenSingleChildDir = 1
let NERDTreeStatusline = 0

" airline
let g:airline_powerline_fonts = 0
let g:airline#extensions#fugitiveline#enabled = 0
let g:airline#extensions#branch#enabled = 0
let g:airline_section_x = airline#section#create([])
let g:airline_section_y = airline#section#create([])
let g:airline_section_z = airline#section#create([])

" fzf
let $FZF_DEFAULT_COMMAND = 'ag --ignore-dir=vendor -g ""'

let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }

" go
let g:go_auto_type_info = 1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_highlight_diagnostic_errors = 1

" bullets.vim
let g:bullets_enabled_file_types = [
            \ 'markdown',
            \ 'text',
            \ 'gitcommit',
            \ 'scratch'
            \]

""
"" Basic configuration
""
set hidden
set number
set cursorline
set ruler
set splitbelow " open new splits below
set splitright " open new splits at the right
set nocompatible " we're running Vim, not Vi!
set ignorecase
set switchbuf=usetab
set colorcolumn=100
set encoding=utf-8
set langmenu=en_US.UTF-8
set term=screen-256color
set number relativenumber
set regexpengine=0
set directory=$HOME/.vim/swapfiles/

" prefer vertical orientation when using :diffsplit
set diffopt+=vertical

" autocomple
set completeopt=longest,menuone

" whitespace
set nowrap " break line after it reachs the limit
set expandtab " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything in insert mode
set tabstop=4
set shiftwidth=4

" search
set hlsearch
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter

""
"" Languages
""
syntax on             " enable syntax highlighting
filetype on           " enable filetype detection
filetype indent on    " enable filetype-specific indenting
filetype plugin on    " enable filetype-specific plugins

""
"" Appearance
""
color smyck
highlight ColorColumn guibg=#303030 ctermbg=0
highlight CursorLine cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkred guifg=white


""
"" Others
""
" tmux will send xterm-style keys when its xterm-keys option is on
if &term =~ '^screen' && exists('$TMUX')
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif


""
"" Keymapping
""
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ea :vsplit $HOME/.config/alacritty/alacritty.yml<cr>
nnoremap <leader>et :vsplit $HOME/.tmux.conf<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" tabs and splits
nnoremap <leader>th :tabm -1<cr>
nnoremap <leader>tl :tabm +1<cr>
nnoremap <S-h> :tabp<cr>
nnoremap <S-l> :tabn<cr>

" buffers
nnoremap <leader>c :bd<cr>
nnoremap <leader>C :bufdo bd!<cr>

" nerdtree
nnoremap <C-f> :NERDTreeToggle<cr>
nnoremap <C-e> :NERDTreeFind<cr>

" searching
vnoremap // y/<C-R>"<CR>
nnoremap <leader>f :FZF<cr>
nnoremap <leader>sh :History:<cr>
nnoremap <leader>gs "+yiw:Ag <C-r>"<cr>
nnoremap <leader>q :noh<cr>

" copy and pasting
vnoremap <C-y> "+y
nnoremap <C-p> :call PasteWithoutIndent()<CR>

function PasteWithoutIndent()
    :set paste
    :put +
    :set nopaste
endfunction

""
"" Commands
""

" strips white spaces on save
autocmd BufWritePre * :%s/\s\+$//e

" go
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>a <Plug>(go-alternate-vertical)

" toggle to absolute line numbers on insert mode
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" automatically resize splits when resizing MacVim window
autocmd VimResized * wincmd =
