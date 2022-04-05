set nu rnu " relative numbers
set sw=4 ts=4 " 4 space tabs
set title
set ruler
set wrap
set autoindent
set smarttab
set incsearch hlsearch " highlight searches
set ignorecase smartcase " ignore case unless we specify it
set noshowmode " mode is shown by the fancy line
set mouse=a " for screen sharing et al
set scrolloff=5 " don't scroll to end of screen
set listchars=tab:\⡀\  " small dot on indent
set list
set breakindent
set formatoptions=l
set lbr
set nofixendofline
set cursorline
set colorcolumn=102 " line of refection
set showbreak=+++++ " indent on wrap with 5 chars for extra readability
set splitbelow splitright " sane defaults for v/h splits
set backspace=indent,eol,start " better backspace
set nobackup " no annoying files
set noswapfile " see below
set updatetime=300
syntax enable

call plug#begin()
" lua deps
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'gruvbox-community/gruvbox' " colorscheme
Plug 'romainl/vim-cool' " disable hlsearch when moving away from match
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'APZelos/blamer.nvim' " gitlens-like line blame
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

Plug 'neovim/nvim-lspconfig' " the big one

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " better syntax highlight
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursor like vscode
Plug 'christoomey/vim-tmux-navigator'

Plug 'vimwiki/vimwiki' " not-org mode
Plug 'mhinz/vim-startify' " useless startup screen

" Golang specifics
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim' " test gen
call plug#end()

" Colors
let g:gruvbox_italic=1 
let g:gruvbox_bold=1
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_transparent_bg='1'
colorscheme gruvbox
set termguicolors " make tmux colors not terrible
" make vim obey transparency in terminal
hi Normal ctermbg=none guibg=none
" make treesitter not turn some chars orange because it looks terrible
hi link Delimiter none
hi Blamer guifg=grey

let mapleader = " "

let g:blamer_enabled = 1
let g:blamer_delay = 300
let g:blamer_relative_time = 1

let g:go_test_show_name = 1

" change tree colors depending on git status
let g:nvim_tree_git_hl = 1 
" disable git icons and folder arrows because they look terrible
let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }

let wiki = {}
" highlight internal lang when using ``` go ``` or similar
let wiki.nested_syntaxes = {'python': 'python', 'go': 'go', 'sh': 'sh', 'sql': 'sql'} 
let g:vimwiki_list = [{'path': '~/.local/share/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}, wiki] " use markdown instead of vimwiki

" change panes faster (also, vim-tmux-navigator bindings)
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <C-P> <cmd>Telescope find_files find_command=rg,--files,--hidden,--no-ignore,-g,!.git<cr>
nnoremap <C-G> <cmd>Telescope live_grep<cr>
nmap <C-n> :NvimTreeToggle<CR>
nnoremap <C-f> :NvimTreeFindFile<CR>
nnoremap Y y$ 
" do change command on visual selection, repeat change when pressing .
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn
" I'm too lazy to type the s///g stuff
vnoremap /s y:%s/<C-R>"//g<Left><Left>
" open error float
nmap <leader>E :lua vim.diagnostic.open_float(nil, {focus=false})<CR>
" config edit shortcut
nmap <leader>vv :e ~/.config/nvim/init.vim<CR>
" yank to OS clipboard, slightly less clunky
nmap <leader>y "+y
" paste last yanks
nmap <leader>p "0p
nmap <leader>P "0P
" git status with lower height
nmap <leader>gg :Git<CR>15<C-W>-

nmap <leader>gt :GoTestFunc<CR>
nmap <leader>gc :GoCoverageToggle<CR>

" vim-visual-multi mapping
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-s>'
let g:VM_maps['Find Subword Under'] = '<C-s>'

" Do not show stupid q: window
map q: :q

" autoclose quickfix windows
autocmd Filetype qf nmap <Enter>  <Enter>:ccl<CR>
" autoformat json on save
autocmd FileType json setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType json autocmd BufWritePre <buffer> %!jq . | head -c -1
" abbreviate aws lambda in markdown
autocmd FileType markdown abbrev awsll λ
" iferr abbreviations for go	
autocmd FileType go abbrev iferr  if err != nil { return nil, err }
autocmd FileType go abbrev erre if err != nil { return err }
autocmd FileType go abbrev errf if err != nil { return fmt.Errorf("%w", err) }
autocmd FileType go abbrev errn if err != nil { return errors.New("") }

" autoclose nvim tree
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" trigger `autoread` when files changes on disk
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

" Restore underline cursor
augroup RestoreCursorShapeOnExit
    autocmd!
    autocmd VimLeave * set guicursor=a:hor20
augroup END

lua << EOF
	require'nvim-web-devicons'.setup()
	require "lsp_signature".setup{
		hint_enable = false,
		handler_opts = {
			border = "none"
		},
	}
	require('lualine').setup {
		options = {
			theme = 'gruvbox',
			component_separators = {},
			section_separators = {}
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'filename', 'diagnostics'},
			lualine_c = {'branch'},
			lualine_x = {'encoding', 'fileformat'},
			lualine_y = {'filetype'},
			lualine_z = {'location'}
		},
	}
	require'nvim-tree'.setup({ open_on_tab = true, view = { width = 35 } })
	require'nvim-treesitter.configs'.setup({highlight = {enable = true}})
	require('telescope').setup({
		defaults = {
			layout_config = {
				horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 }
			},
		},
		pickers = {
			lsp_document_symbols = { show_line = false },
			lsp_definitions = { show_line = false },
			lsp_references = { show_line = false },
			diagnostics = { show_line = false },
			lsp_type_definitions = { show_line = false },
			lsp_implementations = { show_line = false },
		},
	})

	local cmp = require'cmp'

	cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
			['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<C-y>'] = cmp.config.disable,
			['<C-e>'] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			['<CR>'] = cmp.mapping.confirm({ select = false }),
		},
		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' }, 
		},
		{
			{ name = 'buffer' },
		})
	})

	cmp.setup.cmdline('/', {
		sources = {
			{ name = 'buffer' }
		}
	})

	cmp.setup.cmdline(':', {
		sources = cmp.config.sources({
			{ name = 'path' }
		},
		{
			{ name = 'cmdline' }
		})
	})

	vim.diagnostic.config({
		virtual_text = false
	})

	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local on_attach = function(client, bufnr)
		local opts = { noremap=true, silent=true }
		-- LSP keybinds
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>Telescope lsp_document_symbols<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>Telescope lsp_type_definitions<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gE', '<cmd>Telescope diagnostics<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ge', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	end

	require('lspconfig')['gopls'].setup({capabilities = capabilities, on_attach = on_attach})
EOF
