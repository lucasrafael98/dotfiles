----
--
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
vim.opt.updatetime = 20
vim.opt.title = true
vim.opt.titlestring = [[nvim: %t]]
vim.opt.listchars = { space = ' ', tab = '⡀ ' }
vim.opt.foldlevelstart = 99
----

local function map(mode, combo, cmd, noremap)
	opts = {}
	if noremap then 
		opts = {noremap = true}
	end
	vim.api.nvim_set_keymap(mode, combo, cmd, opts)
end


-- quickly access files
map('n', '<leader>vv', ':e ~/.config/nvim/init.lua<CR>', true)
map('n', '<leader>vl', ':e ~/.config/nvim/plug.vim<CR>', true)

vim.pack.add({
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-lua/popup.nvim',

	'https://github.com/nvim-mini/mini.pairs',
	'https://github.com/tpope/vim-surround',
	'https://github.com/nvim-mini/mini.comment',

	'https://github.com/kyazdani42/nvim-web-devicons',
	'https://github.com/ellisonleao/gruvbox.nvim',
	'https://github.com/sindrets/diffview.nvim',
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/kyazdani42/nvim-tree.lua',
	'https://github.com/nvim-lualine/lualine.nvim',

	'https://github.com/hrsh7th/nvim-cmp',
	'https://github.com/hrsh7th/cmp-nvim-lsp',
	'https://github.com/hrsh7th/cmp-buffer',
	'https://github.com/hrsh7th/cmp-path',
	'https://github.com/hrsh7th/cmp-cmdline',
	'https://github.com/L3MON4D3/LuaSnip',
	'https://github.com/saadparwaiz1/cmp_luasnip',
	'https://github.com/ray-x/lsp_signature.nvim',

	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-telescope/telescope-live-grep-args.nvim',

	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', branch = 'main'},
	'https://github.com/nvim-treesitter/nvim-treesitter-context',
	'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',

	'https://github.com/kevinhwang91/promise-async',
	'https://github.com/kevinhwang91/nvim-ufo',

	'https://github.com/knubie/vim-kitty-navigator',

	'https://github.com/supermaven-inc/supermaven-nvim',
	'https://github.com/stevearc/conform.nvim',

	'https://github.com/williamboman/mason.nvim',
})

----
-- Key Mapping
-- yank and paste
map('n', 'Y', 'y$', false) -- replicate D and C
map('', '<leader>y', '"+y', false) -- yank to OS clipboard
map('', '<leader>Y', '"+y$', false) -- yank to OS clipboard
map('n', '<leader>p', '"0p', false) -- paste last yank
map('n', '<leader>P', '"0P', false) -- same as above
-- vim-kitty-navigator 
vim.g.kitty_navigator_no_mappings = 1
map('n', '<C-h>', '<cmd>KittyNavigateLeft<cr>', true)
map('n', '<C-j>', '<cmd>KittyNavigateDown<cr>', true)
map('n', '<C-k>', '<cmd>KittyNavigateUp<cr>', true)
map('n', '<C-l>', '<cmd>KittyNavigateRight<cr>', true)
-- weird black magic
-- do change command on visual selection, repeat change when pressing .
map('v', '//', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>Ncgn', true)
-- I'm too lazy to type the s///g stuff
map('v', '/s', 'y:%s/<C-R>"//g<Left><Left>', true)
-- duplicate json-like field and separate with a comma
map('n', '<leader>{', 'ya{P%a,<CR><Esc>', true)
-- compact json field
map('n', '<leader>}', 'va{<Esc>%i<CR><Esc>%a<CR><ESC>kva{:!jq -c<CR>kJJ', true)
--misc
map('n', '<leader>gv', ':DiffviewOpen<CR>', true)
map('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', true)
map('n', '<C-p>', ':Telescope find_files find_command=rg,--files,-.,-g,!.git<cr>', true)
map('n', '<leader><C-p>', ':Telescope find_files find_command=rg,--files,-.,--no-ignore<cr>', true)
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
-- split resize
map('', '<A-l>', '5<C-W>>', true)
map('', '<A-h>', '5<C-W><', true)
map('', '<A-k>', '5<C-W>+', true)
map('', '<A-j>', '5<C-W>-', true)
-- map incr to ctrl+s so it doesn't interfere with kitty
map('', '<C-s>', '<C-a>', false)
----

----
-- Packages/Misc
require('mini.pairs').setup()
require('mini.comment').setup()
require('nvim-web-devicons').setup()
require('mason').setup()
require("supermaven-nvim").setup({
	condition = function()
		return string.match(vim.fn.expand("%"), "secrets")
	end
})

require('ufo').setup({
	provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end,
	-- hide imports on treesitter-enabled buffers
	close_fold_kinds_for_ft = {default = {'import_declaration'}},
})

require('gitsigns').setup{
	current_line_blame = true,
	current_line_blame_opts = {delay = 0},
	current_line_blame_formatter = '\t\t<author>, <author_time> • <summary>',
	preview_config = {border = 'none'},
}
require('diffview').setup {
	enhanced_diff_hl = true,
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
	git = {enable = false, ignore = false, timeout = 0},
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

-- auto close
local function is_modified_buffer_open(buffers)
    for _, v in pairs(buffers) do
        if v.name:match("NvimTree_") == nil then
            return true
        end
    end
    return false
end

vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if
            #vim.api.nvim_list_wins() == 1
            and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
            and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
        then
            vim.cmd("quit")
        end
    end,
})

local treesitter_langs = {
	'cpp', 'go', 'lua', 'query', 'scheme', 'sql', 'yaml', 'json', 'html', 'proto',
	'css', 'rust', 'vim', 'typescript', 'tsx', 'graphql', 'terraform', 'python'
}
require('nvim-treesitter').setup({})
require('nvim-treesitter').install(treesitter_langs)
for _, lang in pairs(treesitter_langs) do 
	vim.api.nvim_create_autocmd("FileType", {
		pattern = lang,
		callback = function() 
			vim.treesitter.start()
		end
	})
end
require("treesitter-context").setup({
	enable = true, 
	throttle = true, 
	max_lines = 0,
	show_all_context = show_all_context,
	patterns = {
		default = { "function", "method", "for", "while", "if", "switch", "case" }
	},
})

require('telescope').setup({
	defaults = { layout_config = {
		horizontal = { width = 0.9, height = 0.9, preview_width = 0.5 }
	},
	pickers = {
		live_grep = {
			file_ignore_patterns = { 'node_modules', '.git/', '.venv' },
			additional_args = function(_)
				return { "--hidden" }
			end
		},
	}
}})
require("telescope").load_extension("live_grep_args")

-- Auto-complete
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

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true, -- always show errors first in gutter
	signs = true,
	underline = true,
})
----
-- formatting
require("conform").setup({
  formatters_by_ft = {
	  json = { "prettierd" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  notify_on_error = true,
})

----
-- LSP Setup
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = {'ruff', 'basedpyright', 'rust_analyzer', 'golangci_lint_ls', 'ts_ls', 'jsonls', 'cssls', 'kotlin_language_server', 'terraformls'}
for _, lsp in pairs(servers) do 
	vim.lsp.config(lsp, { settings = settings, capabilities=capabilities})
	vim.lsp.enable(lsp)
end
vim.lsp.config('basedpyright', {
	capabilities = capabilities,
	settings = {
		basedpyright = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportAny = "none",
					reportUnusedCallResult = "none",
					reportUnknownVariableType = "none",
					reportImplicitOverride = "none",
					reportMissingTypeStubs = "none",
				},
			}
		}
	}
})
----

----
-- Autocmds
-- set local buffer to use two space indent in below langs
for _, lang in pairs({"json", "yaml", "toml", "html", "css", "typescriptreact", "typescript"}) do 
	vim.api.nvim_create_autocmd({"FileType"},{
		pattern = lang,
		callback = function() 
			vim.opt_local.expandtab = true 
			vim.opt_local.shiftwidth = 2 
			vim.opt_local.tabstop = 2
		end
	})
end

vim.api.nvim_create_autocmd('BufWritePost',{
	callback = function() 
		vim.lsp.buf.format({ async = true })
	end,
	pattern = '*.js,*.ts,*.css,*.tsx',
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
