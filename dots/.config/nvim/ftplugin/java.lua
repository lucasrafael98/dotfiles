local workspace = os.getenv("HOME") .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
local config = {
  cmd = {
		'java', 
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Djava.configuration.maven.defaultMojoExecutionAction=execute',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx4g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-javaagent:' .. os.getenv('HOME') .. '/.local/share/java/lombok-1.18.4.jar',
		'-Xbootclasspath/a:' .. os.getenv('HOME') .. '/.local/share/java/lombok-1.18.4.jar',
		'-jar', os.getenv('HOME') .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.700.v20231214-2017.jar',
		'-configuration', os.getenv('HOME') .. '/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
		'-data', workspace
	},
	root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

vim.opt_local.expandtab = true 
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
