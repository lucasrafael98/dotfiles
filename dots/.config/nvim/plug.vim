call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'ellisonleao/gruvbox.nvim'
Plug 'romainl/vim-cool' " disable hlsearch when moving away from match
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'lewis6991/gitsigns.nvim' " gitgutter + blamer
Plug 'kyazdani42/nvim-web-devicons' " pretty (and useless) icons
Plug 'kyazdani42/nvim-tree.lua' " muh vim ide, part 1
Plug 'nvim-lualine/lualine.nvim' " muh vim ide, part 2

" completion + snippets
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'ray-x/lsp_signature.nvim' " shows definition when filling up func arguments

Plug 'nvim-telescope/telescope.nvim' " fuzzy finder for several things 

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " better syntax highlight
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}

" debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'

Plug 'nvim-neorg/neorg'
Plug 'mhinz/vim-startify' " useless startup screen

" language specifics
Plug 'fatih/vim-go'
Plug 'olexsmir/gopher.nvim'
Plug 'rust-lang/rust.vim'
call plug#end()

let g:rustfmt_autosave = 1
let g:go_test_show_name = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
" disable gopls, since it results in duplicate instances of gopls running and 
" shows annoying messages on startup. fmt/imports on autosave are disabled due to a bug.
let g:go_gopls_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0

" autoclose nvim tree
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
