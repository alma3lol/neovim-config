local dap = require('dap')

dap.adapters.node2 = {
	type = 'executable',
	command = 'node',
	args = {vim.env.CWD .. '/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.adapters.firefox = {
	type = 'executable',
	command = 'node',
	args = {vim.env.CWD .. '/vscode-firefox-debug/dist/adapter.bundle.js'},
}

dap.configurations.javascript = {
	{
		name = 'Run File',
		type = 'node2',
		request = 'launch',
		program = '${workspaceFolder}/${file}',
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = 'inspector',
		console = 'integratedTerminal',
	},
	{
		name = 'Attach to Process',
		type = 'node2',
		request = 'attach',
		restart = true,
		port = 9229
	},
}
dap.configurations.typescript = {
	{
		name = 'Attach to Process',
		type = 'node2',
		request = 'attach',
		restart = true,
		port = 9229
	},
	{
		name = 'Debug using Firefox',
		type = 'firefox',
		request = 'attach',
		reloadOnChange = {
			watch = { '${workspaceFolder}/**/*.tsx?' },
			ignore = { '${workspaceFolder}/node_modules/**' },
		},
		url = 'http://localhost:3000'
	}
}
dap.configurations.typescriptreact = {
	{
		name = 'Debug using Firefox',
		type = 'firefox',
		request = 'attach',
		reloadOnChange = {
			watch = { '${workspaceFolder}/**/*.tsx?' },
			ignore = { '${workspaceFolder}/node_modules/**' },
		},
		url = 'http://localhost:3000'
	}
}

vim.fn.sign_define('DapBreakpoint', {text='B', texthl='Error', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='L', texthl='LspDiagnosticsSignHint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='→', texthl='LspDiagnosticsSignWarning', linehl='debugPC', numhl=''})
