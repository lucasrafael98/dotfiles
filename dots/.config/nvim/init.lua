vim.g.mapleader = ' '

vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 5 -- don't scroll to end of screen
vim.opt.list = true
vim.opt.formatoptions = 'l'
vim.opt.fixendofline = false -- don't add \n on eof
vim.opt.cursorline = true
vim.opt.colorcolumn = "110"
vim.opt.textwidth = 110
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '  ...' -- indent with 5 chars for differentiation
vim.opt.splitbelow = true -- sane defaults for v/h splits
vim.opt.splitright = true
vim.opt.backspace = 'indent,eol,start' -- better backspace
vim.opt.backup = false -- no annoying files
vim.opt.swapfile = false -- see above 
vim.opt.showmode = false -- mode is shown by the fancy line
vim.opt.conceallevel = 2 -- for neorg
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.termguicolors = true -- make tmux colors not terrible

vim.cmd('source ~/.config/nvim/old.vim')

require("gruvbox").setup({
  contrast = "hard", -- can be "hard", "soft" or empty string
  overrides = { Normal = {} },
})
vim.cmd("colorscheme gruvbox")

local function map(mode, combo, cmd, noremap)
	opts = {}
	if noremap then 
		opts = {noremap = true}
	end
	vim.api.nvim_set_keymap(mode, combo, cmd, opts)
end

map('', '<C-h>', '<C-w>h', false)
map('', '<C-j>', '<C-w>j', false)
map('', '<C-k>', '<C-w>k', false)
map('', '<C-l>', '<C-w>l', false)

map('n', '<C-p>', ':Telescope find_files find_command=rg,--files,--hidden,--no-ignore,-g,!.git<cr>', true)
map('n', '<C-g>', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', true)
map('n', '<C-n>', ':NvimTreeToggle<CR>', true)
map('n', '<C-f>', ':NvimTreeFindFile<CR>', true)
map('n', '<leader>t', ':tabnew<CR>', true)

-- enable folding but don't close any folds
map('n', '<leader>zr', ':set foldmethod=expr<CR>zR', true)

map('n', 'Y', 'y$', true)

-- git status with lower height
map('n', '<leader>gg', ':Git<CR>15<C-W>-', true)
map('n', '<leader>gv', ':Gvdiffsplit<CR>', true)
map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', true)
map('n', '<leader>gt', ':GoTestFunc<CR>', true)
map('n', '<leader>gc', ':GoCoverageToggle<CR>', true)
map('v', '<leader>ga', ':GoAddTags<CR>', true)

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

function start_debug() 
	-- disable folding and autofold, otherwise errors occur
	vim.api.nvim_create_augroup('HideImport', {clear=true})
	vim.api.nvim_command('set nofoldenable')
	require('dap.ext.vscode').load_launchjs('.vscode/launch.json')
	require('dap').continue()
	require('dapui').open()
end

function stop_debug() 
	-- re-enable autofold
	vim.api.nvim_create_augroup('HideImport', {clear=true})
	vim.api.nvim_create_autocmd({"BufReadPost"}, {
		pattern = "*.go",
		command = "norm 2j zrzcgg",
	})
	vim.api.nvim_command('set foldenable')
	-- folds everything by setting foldenable, unfold
	vim.api.nvim_command('norm zR')
	require('dap').close()
	require('dapui').close()
end

require('nvim-autopairs').setup()
require('nvim-web-devicons').setup()

require('neorg').setup{ load = {
	["core.defaults"] = {},
	["core.norg.concealer"] = {},
	["core.export"] = {},
	["core.export.markdown"] = {},
	["core.norg.dirman"] = {
		config = { workspaces = { work = "~/Documents/Notes" } }
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
require("treesitter-context").setup({
	enable = true, 
	throttle = true, 
	max_lines = 0,
	show_all_context = show_all_context,
	patterns = {
		default = {
			"function",
			"method",
			"for",
			"while",
			"if",
			"switch",
			"case",
		},
	},
})

require('telescope').setup({ defaults = { layout_config = {
	horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 }
}}})
require("telescope").load_extension("live_grep_args")

require("dapui").setup({
	mappings = {
		expand = "o",
		open = "g",
	},
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.8 },
				{ id = "breakpoints", size = 0.2},
			},
			size = 40, 
			position = "left",
		},
		{
			elements = { "repl" },
			size = 0.2,
			position = "bottom",
		},
	},
})
require('dap-go').setup()

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

-- breakpoint signs
vim.fn.sign_define('DapBreakpoint', 
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition',
{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', {text = ''}) -- disable the gutter sign, it's useless and jittery

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = {'pyright', 'rust_analyzer', 'gopls', 'golangci_lint_ls'}
for _, lsp in pairs(servers) do 
	if lsp == 'gopls' then 
		settings = { gopls = { gofumpt = true } }
	end
	require('lspconfig')[lsp].setup({ settings = settings, capabilities=capabilities})
end
