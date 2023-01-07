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

" small dot on indent
set listchars=tab:\⡀\   

" make treesitter not turn some chars orange because it looks terrible
hi link Delimiter none
hi GitSignsCurrentLineBlame guifg=grey

" duplicate json-like field and separate with a comma
nnoremap <leader>{ ya{P%a,<CR><Esc>
" compact json field
nnoremap <leader>} va{%i%akva{:!jq -c<CR>kJJ

" config edit shortcut
nmap <leader>vv :e ~/.config/nvim/init.lua<CR>
nmap <leader>vl :e ~/.config/nvim/old.vim<CR>
nmap <leader>ww :tabnew<CR>:Neorg workspace work<CR>

" do change command on visual selection, repeat change when pressing .
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn
" I'm too lazy to type the s///g stuff
vnoremap /s y:%s/<C-R>"//g<Left><Left>

" yank to OS clipboard, slightly less clunky
map <leader>y "+y
" paste last yanks
nmap <leader>p "0p
nmap <leader>P "0P

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

" open error float
nmap <leader>E :lua vim.diagnostic.open_float(nil, {focus=false})<CR>
nmap gD :Telescope lsp_document_symbols<CR>
nnoremap gd :Telescope lsp_definitions<CR>
nmap gy :Telescope lsp_type_definitions<CR>
nmap gi :Telescope lsp_implementations<CR>
nmap gE :Telescope diagnostics<CR>
nmap gr :Telescope lsp_references<CR>
nmap ge :lua vim.lsp.buf.rename()<CR>
nmap K :lua vim.lsp.buf.hover()<CR>
nmap ga :lua vim.lsp.buf.code_action()<CR>

" debugging keymaps
nmap <leader>gb :lua require('dapui').toggle()<CR>
nmap <leader>b :lua require('dap').toggle_breakpoint()<CR>
nmap <leader>gd :lua require('dap-go').debug_test()<CR>
nmap <F3> :lua start_debug()<CR>
nmap <F4> :lua stop_debug()<CR>
nmap <F5> :lua require('dap').continue()<CR>
nmap <F10> :lua require('dap').step_over()<CR>
nmap <F11> :lua require('dap').step_into()<CR>
nmap <F12> :lua require('dap').step_out()<CR>

" resize splits
map <A-l> 5<C-W>>
map <A-h> 5<C-W><
map <A-k> 5<C-W>+
map <A-j> 5<C-W>-
