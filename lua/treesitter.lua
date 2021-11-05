require('nvim-treesitter.configs').setup {
	ensure_installed = {
		'javascript',
		'tsx',
		'typescript',
		'regex',
		'python',
		'lua',
		'jsonc',
		'json',
		'jsdoc',
		'html',
		'css',
		'dockerfile'
	},
	highlight = {
		enable = true,
		use_languagetree = true
	},
	incremental_selection = {enable = true},
	textobjects = {enable = true},
	indent = {enable = false},
	rainbow = {enable = true, extended_mode = true},
	context_commentstring = {enable = true},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = {"BufWrite", "CursorHold"}
	}
}


