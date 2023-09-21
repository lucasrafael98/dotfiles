----
-- Vim options
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
vim.opt.foldmethod = 'expr'
vim.opt.updatetime = 20
vim.opt.title = true
vim.opt.titlestring = [[nvim: %f]]
vim.opt.listchars = { space = ' ', tab = '⡀ ' }
----

-- Mostly plugins
vim.cmd('source ~/.config/nvim/plug.vim')

----
-- Key Mapping
local function map(mode, combo, cmd, noremap)
	opts = {}
	if noremap then 
		opts = {noremap = true}
	end
	vim.api.nvim_set_keymap(mode, combo, cmd, opts)
end
-- yank and paste
map('n', 'Y', 'y$', false) -- replicate D and C
map('', '<leader>y', '"+y', false) -- yank to OS clipboard
map('n', '<leader>p', '"0p', false) -- paste last yank
map('n', '<leader>P', '"0P', false) -- same as above
-- weird black magic
-- do change command on visual selection, repeat change when pressing .
map('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>Ncgn', true)
-- I'm too lazy to type the s///g stuff
map('v', '/s', 'y:%s/<C-R>"//g<Left><Left>', true)
-- duplicate json-like field and separate with a comma
map('n', '<leader>{', 'ya{P%a,<CR><Esc>', true)
-- compact json field
map('n', '<leader>}', 'va{<Esc>%i<CR><Esc>%a<CR><ESC>kva{:!jq -c<CR>kJJ', true)
--
-- quickly access files
map('n', '<leader>vv', ':e ~/.config/nvim/init.lua<CR>', true)
map('n', '<leader>vl', ':e ~/.config/nvim/plug.vim<CR>', true)
--misc
map('n', '<leader>gg', ':Neogit<CR>', true) -- git status, lower height
map('n', '<leader>gv', ':DiffviewOpen<CR>', true)
map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', true)
map('n', '<leader>gt', ':GoTestFunc<CR>', true)
map('n', '<leader>gc', ':GoCoverageToggle<CR>', true)
map('v', '<leader>ga', ':GoAddTags<CR>', true)
map('n', '<C-p>', ':Telescope find_files find_command=rg,--files,--hidden,--no-ignore,-g,!.git<cr>', true)
map('n', '<C-g>', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', true)
map('n', '<C-n>', ':NvimTreeToggle<CR>', true)
map('n', '<C-f>', ':NvimTreeFindFile<CR>', true)
map('n', '<leader><leader>', ':Telescope resume<CR>', true)
map('n', '<leader>of', ':Telescope oldfiles<CR>', true)
map('n', '<leader>t', ':tabnew<CR>', true)
map('n', '<leader>zr', ':set foldmethod=expr<CR>zR', true) -- enable folding but don't close any folds
-- lsp
map('n', '<leader>E', ':lua vim.diagnostic.open_float(nil, {focus=false})<CR>', true)
map('n', 'gD', ':Telescope lsp_document_symbols<CR>', true)
map('n', 'gd', ':Telescope lsp_definitions<CR>', true)
map('n', 'gy', ':Telescope lsp_type_definitions<CR>', true)
map('n', 'gi', ':Telescope lsp_implementations<CR>', true)
map('n', 'gE', ':Telescope diagnostics<CR>', true)
map('n', 'gr', ':Telescope lsp_references<CR>', true)
map('n', 'ge', ':lua vim.lsp.buf.rename()<CR>', true)
map('n', 'K', ':lua vim.lsp.buf.hover()<CR>', true)
map('n', 'ga', ':lua vim.lsp.buf.code_action()<CR>', true)
-- debugging 
map('n', '<leader>gb', ':lua require("dapui").toggle()<CR>', true)
map('n', '<leader>b', ':lua require("dap").toggle_breakpoint()<CR>', true)
map('n', '<leader>gd', ':lua require("dap-go").debug_test()<CR>', true)
map('n', '<F3>', ':lua start_debug()<CR>', true)
map('n', '<F4>', ':lua stop_debug()<CR>', true)
map('n', '<F5>', ':lua require("dap").continue()<CR>', true)
map('n', '<F10>', ':lua require("dap").step_over()<CR>', true)
map('n', '<F11>', ':lua require("dap").step_into()<CR>', true)
map('n', '<F12>', ':lua require("dap").step_out()<CR>', true)
-- split resize
map('', '<A-l>', '5<C-W>>', true)
map('', '<A-h>', '5<C-W><', true)
map('', '<A-k>', '5<C-W>+', true)
map('', '<A-j>', '5<C-W>-', true)
-- faster split navigation
map('', '<C-h>', '<C-w>h', false)
map('', '<C-j>', '<C-w>j', false)
map('', '<C-k>', '<C-w>k', false)
map('', '<C-l>', '<C-w>l', false)
-- map incr to ctrl+s so it doesn't interfere with kitty
map('', '<C-s>', '<C-a>', false)
----

----
-- Packages/Misc
require('nvim-autopairs').setup()
require('nvim-web-devicons').setup()
require('Comment').setup()

require('gitsigns').setup{
	current_line_blame = true,
	current_line_blame_opts = {delay = 0},
	current_line_blame_formatter_opts = {relative_time = true}, 
	current_line_blame_formatter = '\t\t<author>, <author_time> • <summary>',
	preview_config = {border = 'none'},
}
require('diffview').setup {
	enhanced_diff_hl = true,
}
require('neogit').setup {
	integrations = { diffview = true }
}
require('lsp_signature').setup({ hint_enable = false, handler_opts = {border = "none"} })
require('lualine').setup {
	options = {theme = 'gruvbox', component_separators = {}, section_separators = {}},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'filename', 'diagnostics'},
		lualine_c = {{'branch', icon = {''}}},
		lualine_x = {'encoding', 'fileformat'},
		lualine_y = {'filetype'},
		lualine_z = {'location'}
	},
}
require('nvim-tree').setup({
	git = {enable = true, ignore = false, timeout = 0},
	open_on_tab = true, view = { width = 35 },
	renderer = { 
		highlight_git = false,
		icons = {
			show = {
				git = false, -- looks terrible, disable
				file = true,
				folder = true, 
				folder_arrow = false,
			}
		} 
	}
})
require('nvim-treesitter.configs').setup({
	ensure_installed = {'cpp', 'go', 'lua', 'query', 'scheme', 'sql', 'yaml', 'json', 'html', 'css', 'rust', 'vim'},
	highlight = { enable = true },
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				['aa'] = '@parameter.outer',
				['ia'] = '@parameter.inner',
				['af'] = '@function.outer',
				['if'] = '@function.inner',
			},
		},
		swap = {
			enable = true,
			swap_next = { ['<leader>a'] = '@parameter.inner' },
			swap_previous = { ['<leader>A'] = '@parameter.inner' },
		}
	}
})
require("treesitter-context").setup({
	enable = true, 
	throttle = true, 
	max_lines = 0,
	show_all_context = show_all_context,
	patterns = {
		default = { "function", "method", "for", "while", "if", "switch", "case" }
	},
})

require('telescope').setup({ defaults = { layout_config = {
	horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 }
}}})
require("telescope").load_extension("live_grep_args")

-- Auto-complete
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.setup({
	snippet = {expand = function(args) require('luasnip').lsp_expand(args.body) end },
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
	sources = cmp.config.sources({{name = 'nvim_lsp'}, {name = 'luasnip'}}, {{name = 'buffer'}})
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
----

----
-- LSP Setup
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = {'pyright', 'rust_analyzer', 'gopls', 'golangci_lint_ls', 'tsserver', 'eslint', 'terraformls', 'jsonls'}
for _, lsp in pairs(servers) do 
	if lsp == 'gopls' then 
		settings = { gopls = { gofumpt = true } }
	end
	require('lspconfig')[lsp].setup({ settings = settings, capabilities=capabilities})
end
----

----
-- Go stuff
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
require("gopher").setup()
----

----
-- Debugging
function start_debug() 
	require('dap.ext.vscode').load_launchjs('.vscode/launch.json')
	require('dap').continue()
	require('dapui').open()
end
function stop_debug() 
	require('dap').close()
	require('dapui').close()
end
-- breakpoint signs
vim.fn.sign_define('DapBreakpoint', 
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition',
{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', {text = ''}) -- disable the gutter sign, it's useless and jittery
-- dap ui
require("dapui").setup({
	mappings = { expand = "o", open = "g" },
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.8 },
				{ id = "breakpoints", size = 0.2},
			},
			size = 40, position = "left",
		},
		{
			elements = { "repl" },
			size = 0.2,
			position = "bottom",
		},
	},
})
require('dap-go').setup {
  dap_configurations = {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
  },
  delve = { path = "dlv" },
}
----

----
-- Autocmds
-- set local buffer to use two space indent in below langs
for _, lang in pairs({"json", "yaml", "toml", "html", "css"}) do 
	vim.api.nvim_create_autocmd({"FileType"},{
		pattern = lang,
		callback = function() 
			vim.opt_local.expandtab = true 
			vim.opt_local.shiftwidth = 2 
			vim.opt_local.tabstop = 2
		end
	})
end
vim.api.nvim_create_autocmd({"FileType"},{
	pattern = "cucumber",
	callback = function() 
		vim.opt_local.expandtab = true 
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end
})

-- don't fold everything by default
vim.api.nvim_create_autocmd('BufReadPost,FileReadPost',{
	callback = function() vim.cmd("norm zR") end,
	pattern = '*',
})


-- format json on save - TODO: doesn't work on proper lua
vim.cmd("autocmd FileType json autocmd BufWritePre <buffer> %!jq . | head -c -1")

-- iferr abbreviations, folding
vim.api.nvim_create_autocmd('FileType',{
	callback = function() 
		vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
		map('n', '<leader>e', ':GoIfErr<CR>', false)
	end,
	pattern = 'go',
})
-- format + goimports go on save
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format({ async = true })
		goimports(1000)
	end,
	pattern = '*.go'
})
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
	pattern = '*.[a-z]s'
})
-- autocmd to fold imports when entering a file
vim.api.nvim_create_autocmd({"BufReadPost"}, {
	pattern = "*.go",
	callback = function() 
		local bufnr = vim.api.nvim_get_current_buf()

		-- import list query
		local root = vim.treesitter.get_parser(bufnr, "go"):parse()[1]:root()
		local query = vim.treesitter.query.parse("go","(import_declaration (import_spec_list) @import)")

		-- if there are matches, fold stuff
		local _, found = query:iter_matches(root, buf)()
		if found then 
			-- zx is because telescope screws up some folds
			vim.cmd("norm zxzRgg")
			vim.cmd("/import (")
			vim.cmd("norm zcgg")
		end
	end,
})

-- highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- Disable highlight after searching
vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
		if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
	end
end, vim.api.nvim_create_namespace "auto_hlsearch")
----

-- Colour
require("gruvbox").setup({
  contrast = "hard", 
  transparent_mode = true,
  overrides = { 
	  String = { italic = false },
	  Operator = { italic = false },
  },
})
vim.cmd.colorscheme("gruvbox")
-- make treesitter not turn some chars orange because it looks terrible
vim.cmd("hi link Delimiter none")
vim.cmd("hi GitSignsCurrentLineBlame guifg=grey")

require("startup").setup({
    header = {
        type = "text",
        align = "center",
        title = "Header",
        margin = 5,
        content = require("startup.headers").hydra_header,
        highlight = "Statement",
    },
    header_2 = {
        type = "text",
        align = "center",
        title = "Quote",
        margin = 5,
        content = require("startup.functions").quote(),
        highlight = "Constant",
    },
    body = {
        type = "mapping",
        align = "center",
        title = "Basic Commands",
        margin = 5,
        content = {
            { " Find File", "Telescope find_files", "<leader>ff" },
            { " Find Word", "Telescope live_grep", "<leader>lg" },
            { " Recent Files", "Telescope oldfiles", "<leader>of" },
            { " File Browser", ":NvimTreeToggle", "<leader>fb" },
            { " Edit Empty", ":enew", "e" },
			{ " Exit", ":qa!", "q"}
        },
        highlight = "String",
    },
    options = {
        disable_statuslines = true,
        paddings = { 12, 3, 3, 0 },
    },
    parts = { "header", "header_2", "body" },
})
