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
		'dockerfile',
		'norg',
		'norg_meta',
		'norg_table',
	},
	highlight = {
		enable = true,
		-- use_languagetree = true,
		additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<CR>",
			scope_incremental = "<CR>",
			node_incremental = "<TAB>",
			node_decremental = "<S-TAB>",
		},
	},
	textobjects = {
		enable = true,
		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["<leader>df"] = "@function.outer",
				["<leader>dc"] = "@class.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["[["] = "@function.outer",
				["[;"] = "@call.outer",
				["<leader>of"] = "@function.outer",
				["<leader>oc"] = "@conditional.outer",
				["<leader>if"] = "@function.inner",
				["<leader>ic"] = "@conditional.inner",
			},
			goto_next_end = {
				["[]"] = "@function.outer",
				["['"] = "@call.outer",
			},
			goto_previous_start = {
				["]]"] = "@function.outer",
				["];"] = "@call.outer",
				["<leader><leader>of"] = "@function.outer",
				["<leader><leader>oc"] = "@conditional.outer",
				["<leader><leader>if"] = "@function.inner",
				["<leader><leader>ic"] = "@conditional.inner",
			},
			goto_previous_end = {
				["]["] = "@function.outer",
				["]'"] = "@call.outer",
			},
		},
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["of"] = "@function.outer",
				["if"] = "@function.inner",
				["oc"] = "@call.outer",
				["ic"] = "@call.inner",
				["oC"] = "@class.outer",
				["iC"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				[",a"] = "@parameter.inner",
			},
			swap_previous = {
				[",A"] = "@parameter.inner",
			},
		},
	},
	textsubjects = {
		enable = true,
		keymaps = {
			['.'] = 'textsubjects-smart',
			[';'] = 'textsubjects-container-outer',
		}
	},
	indent = { enable = true },
	matchup = { enable = true },
	autopairs = { enable = true },
	rainbow = {enable = true, extended_mode = true},
	context_commentstring = {enable = true},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = {"BufWrite", "CursorHold"}
	},
	refactor = {
		highlight_definitaions = { enable = true },
		highlight_current_scope = { enable = true },
		smart_rename = {
			enable = true,
			keymaps = {
				smart_rename = "grr",
			},
		},
		navigation = {
			enable = true,
			keymaps = {
				goto_definition = "gnd",
				list_definitions = "gnD",
				list_definitions_toc = "gO",
				goto_next_usage = "<a-*>",
				goto_previous_usage = "<a-#>",
			},
		},
	}
}
