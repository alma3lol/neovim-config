local saga = require 'lspsaga'

saga.init_lsp_saga {
	code_action_keys = { quit = '<ESC>',exec = '<CR>' },
	finder_action_keys = {
		open = '<CR>', vsplit = 'v',split = 's',quit = '<ESC>',scroll_down = '<C-f>', scroll_up = '<C-b>'
	},
	border_style = "round"
}
