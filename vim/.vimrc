""
"" Plugins
""
call plug#begin('~/.vim/plugins')

" misc
Plug 'airblade/vim-gitgutter'
Plug 'brendonrapp/smyck-vim' " my favorite colorscheme
Plug 'christoomey/vim-tmux-navigator'
Plug 'github/copilot.vim'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'jeetsukumaran/vim-indentwise' " indent based motions
Plug 'junegunn/vim-easy-align' " align text
Plug 'scrooloose/nerdtree' " filesystem explorer
Plug 'tpope/vim-endwise' " adds end to ruby blocks
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-surround' " surround text objects
Plug 'vim-airline/vim-airline' " very useful fixed bar

" file & code navigation
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' } " improves sorting speed
Plug 'jonarrien/telescope-cmdline.nvim'
Plug 'windwp/nvim-autopairs' " auto pairs for brackets, quotes, etc

" languages
Plug 'tpope/vim-rails'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'

" autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'  " Integration with LSP
Plug 'hrsh7th/cmp-buffer'    " Suggestions from the current buffer
Plug 'hrsh7th/cmp-path'      " Suggestions for file paths
Plug 'hrsh7th/cmp-cmdline'   " Suggestions for the command line

" lsp & parsers
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'wansmer/treesj'
Plug 'dense-analysis/ale'

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
let g:ale_lint_on_enter = 1     " Executa o lint ao abrir o arquivo
let g:ale_lint_on_save = 1      " Executa o lint ao salvar o arquivo
let g:ale_echo_cursor = 1
let g:ale_virtualtext = 0
let g:ale_lint_on_text_changed = 'always'  " Linta ao modificar o texto
" let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
let g:ale_fix_on_save = 1
let g:ale_linters = {'ruby': ['rubocop', 'reek'], 'markdown': ['languagetool'], 'javascript': ['prettier'] }
let g:ale_fixers = {'ruby': ['rubocop'], 'javascript': ['eslint'], '*': ['remove_trailing_lines', 'trim_whitespace']}



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

" highlight
highlight NormalFloat guibg=#1f2335
highlight FloatBorder guifg=white guibg=#1f2335
set updatetime=0

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
nnoremap <leader>ev :tabe $MYVIMRC<CR>
nnoremap <leader>ea :vsplit $HOME/.config/alacritty/alacritty.yml<CR>
nnoremap <leader>et :tabe $HOME/.tmux.conf<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>:noh<CR>
nnoremap <leader><leader> :Telescope cmdline<CR>
nnoremap g<S-S> :TSJSplit<CR>
nnoremap g<S-J> :TSJJoin<CR>

" lsp
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>


" tabs and splits
nnoremap <leader>th :tabm -1<CR>
nnoremap <leader>tl :tabm +1<CR>
nnoremap <S-h> :tabp<CR>
nnoremap <S-l> :tabn<CR>

" buffers
nnoremap <leader>c :bd<CR>
nnoremap <leader>C :bufdo bd!<CR>

" nerdtree
nnoremap <C-f> :NERDTreeToggle<CR>
nnoremap <C-e> :NERDTreeFind<CR>

" searching
nnoremap <leader>f <cmd>Telescope find_files<CR>
nnoremap <leader>g <cmd>Telescope live_grep<CR>
nnoremap <leader>b <cmd>Telescope buffers<CR>
nnoremap <leader>h <cmd>Telescope help_tags<CR>
nnoremap <leader>q :noh<CR>
nnoremap giw :lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })<CR>
nnoremap gi<S-W> :lua require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cWORD>') })<CR>
vnoremap // y/<C-R>"<CR>

" copy and pasting
vnoremap <C-y> "+y
nnoremap <C-p> :call PasteWithoutIndent()<CR>

function PasteWithoutIndent()
    :set paste
    :put +
    :set nopaste
endfunction

" git
" nnoremap <leader>gg :Git<CR>

"" easy align

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

lua << EOF
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {"ruby_lsp", "solargraph", "vimls"},
})


-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig').ruby_lsp.setup {
  capabilities = capabilities,
  init_options = {
      linters = {},
  },
}
require('lspconfig').solargraph.setup {
  capabilities = capabilities,
}

require('lspconfig').vimls.setup {
  capabilities = capabilities
}

-- Setup for nvim-cmp without snippets, with automatic completion
-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    })
})


-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.9,
      height = 0.9,
      preview_height = 0.5,
      preview_cutoff = 0,
    },
    path_display = {"truncate"},
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    cmdline = {
      -- Adjust telescope picker size and layout
      picker = {
        layout_config = {
          width  = 120,
          height = 25,
        }
      },
      -- Adjust your mappings
      mappings    = {
        complete      = '<Tab>',
        run_selection = '<C-CR>',
        run_input     = '<CR>',
        i             = {
            ["<j>"] = require('telescope.actions').move_selection_next,
            ["<k>"] = require('telescope.actions').move_selection_previous,
        },
      },
      -- Triggers any shell command using overseer.nvim (`:!`)
      overseer    = {
        enabled = true,
      },
    },
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')

-- Set up tree
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "ruby", "javascript", "typescript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    -- additional_vim_regex_highlighting = false,
  },
}

require("nvim-autopairs").setup {
  disable_filetype = { "TelescopePrompt" , "vim" },
}

require('treesj').setup {
  enable = true,
  ignore = { "TelescopePrompt" },
}
EOF

lua << EOF
-- Set up diagnostic configuration
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    source = "always",  -- always open the float
    header = "",        -- no header
    prefix = "- ",        -- no prefix
  },
})

-- Set up autocommands to open the diagnostics float window
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      source = "always",  -- always open the float
    })
  end,
})

-- Set up signs
local signs = { Error = "✘", Warn = "⚠", Hint = "➤", Info = "ℹ" }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
EOF
