let mapleader = " "

set mouse=a
set number relativenumber 
set shiftwidth=4 tabstop=4 smarttab " indent with tabs of four, the correct way
set incsearch hlsearch " highlight searches
set ignorecase smartcase " ignore case unless we specify it
set scrolloff=5 " don't scroll to end of screen
set list listchars=tab:\⡀\  " small dot on indent
set formatoptions=l
set nofixendofline " don't add \n on eof
set cursorline colorcolumn=110 " line of reflection
set wrap linebreak breakindent showbreak=\ \ ... " indent with 5 chars for differentiation
set splitbelow splitright " sane defaults for v/h splits
set backspace=indent,eol,start " better backspace
set nobackup " no annoying files
set noswapfile " see above
set noshowmode " mode is shown by the fancy line
set conceallevel=2 " for neorg

call plug#begin()
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'

Plug 'gruvbox-community/gruvbox' " colorscheme
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
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursor like vscode
Plug 'christoomey/vim-tmux-navigator'

" Plug 'vimwiki/vimwiki' " not-org mode
Plug 'nvim-neorg/neorg'
Plug 'mhinz/vim-startify' " useless startup screen

" language specifics
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim'
Plug 'rust-lang/rust.vim'
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
hi GitSignsCurrentLineBlame guifg=grey

" change panes faster (also, vim-tmux-navigator bindings)
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <C-p> <cmd>Telescope find_files find_command=rg,--files,--hidden,--no-ignore,-g,!.git<cr>
nnoremap <C-g> <cmd>Telescope live_grep<cr>
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-f> :NvimTreeFindFile<CR>
nnoremap <leader>t :tabnew<CR>
" duplicate json-like field and separate with a comma
nnoremap <leader>{ ya{P%a,<CR><Esc>

" config edit shortcut
nmap <leader>vv :e ~/.config/nvim/init.vim<CR>
nmap <leader>ww :tabnew<CR>:Neorg workspace work<CR>

" do change command on visual selection, repeat change when pressing .
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>Ncgn
" highlight visual selection matches
vnoremap /. y/\V<C-R>=escape(@",'/\')<CR><CR>N
nnoremap /. viwy/\V<C-R>=escape(@",'/\')<CR><CR>N
" I'm too lazy to type the s///g stuff
vnoremap /s y:%s/<C-R>"//g<Left><Left>

nnoremap Y y$ 
" yank to OS clipboard, slightly less clunky
map <leader>y "+y
" paste last yanks
nmap <leader>p "0p
nmap <leader>P "0P

" git status with lower height
nnoremap <leader>gg :Git<CR>15<C-W>-
nnoremap <leader>gv :Gvdiffsplit<CR>
nnoremap <leader>gp :Gitsigns preview_hunk<CR>

nnoremap <leader>gt :GoTestFunc<CR>
nnoremap <leader>gc :GoCoverageToggle<CR>
vnoremap <leader>ga :GoAddTags<CR>

" Do not show stupid q: window
map q: :q

let g:rustfmt_autosave = 1
let g:go_test_show_name = 1
let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
" disable gopls, since it results in duplicate instances of gopls running and 
" shows annoying messages on startup. fmt/imports on autosave are disabled due to a bug.
let g:go_gopls_enabled = 0
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0

" disable git icons and folder arrows because they look terrible
let g:nvim_tree_show_icons = {'git': 0, 'folders': 1, 'files': 1, 'folder_arrows': 0}

let g:VM_maps = {} " vim-visual-multi mapping
let g:VM_maps['Find Under']         = '<C-s>'
let g:VM_maps['Find Subword Under'] = '<C-s>'

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
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua goimports(10)

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

lua << EOF
	-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
	function goimports(wait_ms)
		local params = vim.lsp.util.make_range_params()
		params.context = {only = {"source.organizeImports"}}
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
		for _, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
				else
					vim.lsp.buf.execute_command(r.command)
				end
			end
		end
	end

	require('nvim-autopairs').setup()
	require('nvim-web-devicons').setup()

	require('neorg').setup{ load = {
		["core.defaults"] = {},
		["core.norg.concealer"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {},
		["core.norg.dirman"] = {
			config = { workspaces = { work = "~/work/norg" } }
		},
	} }
	require('gitsigns').setup{
		current_line_blame = true,
		current_line_blame_opts = {delay = 0},
		current_line_blame_formatter_opts = {relative_time = true}, 
		current_line_blame_formatter = '\t\t<author>, <author_time> • <summary>',
		preview_config = {border = 'none'},
	}
	require('lsp_signature').setup({ hint_enable = false, handler_opts = {border = "none"} })
	require('lualine').setup {
		options = {theme = 'gruvbox', component_separators = {}, section_separators = {}},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'filename', 'diagnostics'},
			lualine_c = {'branch'},
			lualine_x = {'encoding', 'fileformat'},
			lualine_y = {'filetype'},
			lualine_z = {'location'}
		},
	}
	require('nvim-tree').setup({
		git = {enable = true, ignore = false, timeout = 0},
		open_on_tab = true, view = { width = 35 },
	})
	require('nvim-treesitter.configs').setup({ highlight = {enable = true} })
	require('telescope').setup({ defaults = { layout_config = {
		horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 }
	}}})

	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	local cmp = require('cmp')
	cmp.setup({
		snippet = {expand = function(args) vim.fn["vsnip#anonymous"](args.body) end},
		mapping = {
			['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
			['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<C-y>'] = cmp.config.disable,
			['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
			['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { 'i', 'c' }),
			['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }), { 'i', 'c' }),
		},
		sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'vsnip'}}, {{name = 'buffer'}})
	})
	cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})
	cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})
	cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = {tex = ''}}))

	vim.diagnostic.config({
		virtual_text = false,
		severity_sort = true, -- always show errors first in gutter
		signs = true,
		underline = true,
	})

	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	local servers = {'pyright', 'rust_analyzer', 'gopls', 'golangci_lint_ls'}
	for _, lsp in pairs(servers) do 
		if lsp == 'gopls' then 
			settings = { gopls = { gofumpt = true } }
		end
		require('lspconfig')[lsp].setup({ settings = settings, capabilities=capabilities})
	end
EOF
