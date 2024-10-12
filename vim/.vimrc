""
"" Plugins
""
call plug#begin('~/.vim/plugins')

" mist
Plug 'scrooloose/nerdtree' " filesystem explorer
Plug 'vim-airline/vim-airline' " very useful fixed bar
Plug 'jeetsukumaran/vim-indentwise' " indent based motions
Plug 'christoomey/vim-tmux-navigator'
Plug 'github/copilot.vim'
Plug 'andrewradev/splitjoin.vim' " split and join lines
Plug 'junegunn/vim-easy-align'
Plug 'dense-analysis/ale'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'

"" go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

"" clojure
Plug 'tpope/vim-fireplace'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'

" other languages
Plug 'tpope/vim-rails'
Plug 'sheerun/vim-polyglot'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " fuzzyfinder plugin for vim

" git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" colorschemes
Plug 'brendonrapp/smyck-vim'

" lsp
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

call plug#end()


""
"" Variables
""
let mapleader = "-"
let g:vimsyn_embed = 'lr'

" nerdtree
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeChDirMode = 1
let NERDTreeDirArrowCollapsible = '-'
let NERDTreeDirArrowExpandable = '+'
let NERDTreeDirArrows = 1
let NERDTreeMapOpenInTab = '<C-t>'
let NERDTreeMapOpenSplit = '<C-s>'
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
let g:airline_section_z = airline#section#create(['%5(%c%V%)'.g:airline_symbols.space, 'linenr', 'maxlinenr'])


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
" copilot
let g:copilot_filetypes = {
            \ '*': v:true,
            \ 'go': v:false,
            \ }

" ale
let g:ale_fixers = {'ruby': ['rubocop', 'reek'], 'javascript': ['eslint']}

""
"" Basic configuration
""
if !has('nvim')
    set term=screen-256color
endif

set nocompatible
set autoread
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set formatoptions+=j
set complete-=i

set hidden
set number
set cursorline
set ruler
set splitbelow " open new splits below
set splitright " open new splits at the right
set ignorecase
set switchbuf=usetab
set encoding=utf-8
set langmenu=en_US.UTF-8
set number relativenumber
set regexpengine=0
set directory=$HOME/.vim/swapfiles/
set colorcolumn=100

" prefer vertical orientation when using :diffsplit
set diffopt+=vertical

" whitespace
set nowrap " break line after it reachs the limit
set expandtab " use spaces, not tabs
set backspace=indent,eol,start " backspace through everything in insert mode
set tabstop=4
set shiftwidth=4
set nostartofline
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

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
" highlight ColorColumn guibg=#303030 ctermbg=0
" highlight CursorLine cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkred guifg=white


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
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>ea :vsplit $HOME/.config/alacritty/alacritty.yml<cr>
nnoremap <leader>et :tabe $HOME/.tmux.conf<cr>
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
nnoremap <leader>q :noh<cr>

" copy and pasting
vnoremap <C-y> "+y
nnoremap <C-p> :call PasteWithoutIndent()<CR>

function PasteWithoutIndent()
    :set paste
    :put +
    :set nopaste
endfunction

" lsp
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap gs "+yiw:Ag <C-r>"<cr>

" git
nnoremap <leader>gg :Git<cr>

" easy align

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

""
"" Commands
""

command AC :execute "vsp " . eval('rails#buffer().alternate()')

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

" automatically creates the directory of the file being saved
augroup CreatlDir
    autocmd!
    autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

" strips white spaces on save
autocmd BufWritePre * :call TrimWhitespace()

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\_s*\%$//e
    call winrestview(l:save)
endfun

lua << EOF
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {"ruby_lsp", "solargraph", "lua_ls"},
})

require('lspconfig').ruby_lsp.setup({
  init_options = {
    formatter = 'rubocop',
    linters = {'reek', 'rubocop'},
  },
})

require('lspconfig').solargraph.setup({
})
EOF
