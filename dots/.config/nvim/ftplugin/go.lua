map('n', '<leader>gt', ':GoTestFunc<CR>', true)
map('n', '<leader>gc', ':GoCoverageToggle<CR>', true)
map('v', '<leader>ga', ':GoAddTags<CR>', true)
map('n', '<leader>gd', ':lua require("dap-go").debug_test()<CR>', true)

require('lspconfig')['gopls'].setup({ 
	settings = { gopls = { gofumpt = true } },
	capabilities =  require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
})

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

map('n', '<leader>gb', ':lua require("dapui").toggle()<CR>', true)
map('n', '<leader>b', ':lua require("dap").toggle_breakpoint()<CR>', true)
map('n', '<F3>', ':lua start_debug()<CR>', true)
map('n', '<F4>', ':lua stop_debug()<CR>', true)
map('n', '<F5>', ':lua require("dap").continue()<CR>', true)
map('n', '<F10>', ':lua require("dap").step_over()<CR>', true)
map('n', '<F11>', ':lua require("dap").step_into()<CR>', true)
map('n', '<F12>', ':lua require("dap").step_out()<CR>', true)

-- breakpoint signs
vim.fn.sign_define('DapBreakpoint', 
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition',
{ text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected',
{ text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', {text = ''}) -- disable the gutter sign, it's useless and jittery
----

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
