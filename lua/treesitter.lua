require('nvim-treesitter.configs').setup {
	ensure_installed = {'javascript', 'tsx', 'typescript', 'regex', 'python', 'lua', 'jsonc', 'json', 'jsdoc', 'html', 'css', 'dockerfile'},
	highlight = { enable = true },
	incremental_selection = {enable = true},
	textobjects = {enable = true},
	indent = {enable = true},
	rainbow = {enable = true, extended_mode = true}
}


