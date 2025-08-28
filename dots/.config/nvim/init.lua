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
vim.opt.foldmethod = 'expr'
vim.opt.updatetime = 20
vim.opt.title = true
vim.opt.titlestring = [[nvim: %t]]
vim.opt.listchars = { space = ' ', tab = '⡀ ' }
----

-- autoinstall vim-plug if on a fresh machine
if (vim.fn.isdirectory(os.getenv('HOME') .. '/.local/share/nvim/site/autoload') == 0) then
	os.execute("sh -c 'curl -fLo \"${XDG_DATA_HOME:-$HOME/.local/share}\"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'")
end

-- mostly loading plugins with vim-plug
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
map('', '<leader>Y', '"+y$', false) -- yank to OS clipboard
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
require('mason').setup()
require('nvim-ts-autotag').setup({
	autotag = {
		filetypes = { 'xml', 'html', 'typescriptreact' }
	}
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
	ensure_installed = {
		'cpp', 'go', 'lua', 'query', 'scheme', 'sql', 'yaml', 'json',
		'html', 'css', 'rust', 'vim', 'typescript', 'tsx', 'graphql', 'terraform'
	},
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
local servers = {'pyright', 'rust_analyzer', 'golangci_lint_ls', 'ts_ls', 'terraformls', 'jsonls', 'cssls', 'kotlin_language_server'}
for _, lsp in pairs(servers) do 
	require('lspconfig')[lsp].setup({ settings = settings, capabilities=capabilities})
end
require('lspconfig')['eslint'].setup({ root_dir = require('lspconfig').util.root_pattern(".git", "package.json") })

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.prettierd
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
vim.api.nvim_create_autocmd({"FileType"},{
	pattern = "cucumber",
	callback = function() 
		vim.opt_local.expandtab = true 
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end
})

-- format json on save - TODO: doesn't work on proper lua
vim.cmd("autocmd FileType json autocmd BufWritePre <buffer> %!jq .")

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
