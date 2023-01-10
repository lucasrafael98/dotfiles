call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'ellisonleao/gruvbox.nvim'
Plug 'romainl/vim-cool' " disable hlsearch when moving away from match
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
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
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim' " shows definition when filling up func arguments

Plug 'nvim-telescope/telescope.nvim' " fuzzy finder for several things 

Plug 'neovim/nvim-lspconfig'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " better syntax highlight
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursor like vscode
Plug 'knubie/vim-kitty-navigator', {'do': 'cp ./*.py ~/.config/kitty/'}

" debugging
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'

Plug 'nvim-neorg/neorg'
Plug 'mhinz/vim-startify' " useless startup screen

" language specifics
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim'
Plug 'rust-lang/rust.vim'
call plug#end()

" make treesitter not turn some chars orange because it looks terrible
hi link Delimiter none
hi GitSignsCurrentLineBlame guifg=grey

let g:rustfmt_autosave = 1
let g:go_test_show_name = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
" disable gopls, since it results in duplicate instances of gopls running and 
" shows annoying messages on startup. fmt/imports on autosave are disabled due to a bug.
let g:go_gopls_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0

let g:VM_maps = {} " vim-visual-multi mapping
let g:VM_maps['Find Under']         = '<C-s>'
let g:VM_maps['Find Subword Under'] = '<C-s>'

" vim likes folding everything by default which is annoying, open all folds on entering file
autocmd BufReadPost,FileReadPost norg norm zR
" autoformat json on save
autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2 
autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType html setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType css setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType toml setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType json autocmd BufWritePre <buffer> %!jq . | head -c -1
" abbreviate aws lambda in markdown
autocmd FileType norg abbrev awsll λ
autocmd FileType norg nnoremap <leader>xx 0f[lrx
autocmd FileType norg nnoremap <leader>xa }bo- [ ] 
" iferr abbreviations for go	
autocmd FileType go abbrev iferr if err != nil { return nil, err }
autocmd FileType go abbrev erre if err != nil { return err }
autocmd FileType go abbrev errf if err != nil { return fmt.Errorf("%w", err) }
autocmd FileType go abbrev errn if err != nil { return errors.New("") }
autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })
autocmd BufWritePre *.go lua goimports(1000)
" don't fold anything by default
autocmd BufReadPost * norm zR

function HideGoImports()
	" zx is because telescope screws up some folds, need to zx to reeval folds
	:norm zxzRgg
	/import (
	:norm zcgg
endfunction

" autoclose nvim tree
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
