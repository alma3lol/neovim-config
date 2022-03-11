require'lualine'.setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = '|',
		section_separators = { left = '', right = '' },
		disabled_filetypes = {}
	},
	sections = {
		lualine_a = {
			{ 'mode', separator = { left = '' }, right_padding = 2 },
		},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {
			'filename',
			'filesize',
			"os.date('%A, %d %B %Y')",
			{ 'lsp_client_names()', icon = '', color = { fg = '#e0af68', gui = 'bold' }, },
			"require'lsp-status'.status()",
			{ "require('package-info').get_status()", color = { gui = 'bold' }, cond = function() return require('package-info').get_status() == '' end },
			{ "require('nvim-gps').get_location()", cond = function () return require('nvim-gps').is_available() end },
		},
		lualine_x = {
			'encoding',
			'fileformat',
			'filetype'
		},
		lualine_y = {
			'battery_status()',
			'progress',
		},
		lualine_z = {
			{ 'location', separator = { right = '' }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	extensions = {}
}
