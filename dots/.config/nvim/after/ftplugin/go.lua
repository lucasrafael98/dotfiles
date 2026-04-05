vim.pack.add({
	'https://github.com/ray-x/guihua.lua',
	'https://github.com/ray-x/go.nvim',
})

vim.api.nvim_set_keymap('n', '<leader>gt', ':GoTestFunc<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', ':GoCoverage<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<leader>ga', ':GoAddTag<CR>', { noremap = true })

vim.lsp.config('gopls', { 
	settings = { gopls = { gofumpt = true } },
	capabilities =  require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
})
vim.lsp.enable('gopls')

require("go").setup()
----

-- iferr abbreviations, folding
vim.api.nvim_create_autocmd('FileType',{
	callback = function() 
		vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo[0][0].foldmethod = 'expr'
		vim.opt.foldlevel = 99
		map('n', '<leader>e', ':GoIfErr<CR>', false)
		vim.treesitter.start()
	end,
	pattern = 'go',
})
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		vim.cmd("GoImports")
	end,
	pattern = '*.go'
})
