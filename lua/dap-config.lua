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

dap.adapters.chrome = {
	type = 'executable',
	command = 'node',
	args = {vim.env.CWD .. '/vscode-chrome-debug/out/src/chromeDebug.js'},
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
		name = 'Attach to Node Process',
		type = 'node2',
		request = 'attach',
		restart = true,
		port = 9229
	},
	{
		name = 'Attach to Electron Process',
		type = 'chrome',
		request = 'attach',
		restart = true,
		webRoot = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		timeout = 30000,
	},
}
dap.configurations.typescript = {
	{
		name = 'Attach to Node Process',
		type = 'node2',
		request = 'attach',
		restart = true,
		port = 9229
	},
	{
		name = 'Attach to Electron Process',
		type = 'chrome',
		request = 'attach',
		restart = true,
		webRoot = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		timeout = 30000,
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
	},
	{
		name = "Run Jest Tests",
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/node_modules/react-scripts/bin/react-scripts.js",
		args = { "test" },
		console = "integratedTerminal",
		internalConsoleOptions = "neverOpen",
		disableOptimisticBPs = true,
		cwd = "${workspaceFolder}"
	},
}
dap.configurations.typescriptreact = {
	{
		name = 'Attach to Electron Process',
		type = 'chrome',
		request = 'attach',
		restart = true,
		webRoot = "${workspaceFolder}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		timeout = 30000,
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
	},
	{
		name = "Run Jest Tests",
		type = "node2",
		request = "launch",
		program = "${workspaceFolder}/node_modules/react-scripts/bin/react-scripts.js",
		args = { "test" },
		console = "integratedTerminal",
		internalConsoleOptions = "neverOpen",
		disableOptimisticBPs = true,
		cwd = "${workspaceFolder}"
	},
}

vim.fn.sign_define('DapBreakpoint', {text='B', texthl='Error', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='L', texthl='LspDiagnosticsSignHint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='→', texthl='LspDiagnosticsSignWarning', linehl='debugPC', numhl=''})
