local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')
local git_branch = require('feline.providers.git').git_branch
local package = require("package-info")
local gps = require("nvim-gps")

local fn = vim.fn

local properties = {
	force_inactive = {
		filetypes = {},
		buftypes = {},
		bufnames = {}
	}
}

local components = {
	active = {
		{
			{
				provider = '▊ ',
				hl = {
					fg = 'skyblue'
				}
			},
			{
				provider = 'vi_mode',
				icon = '',
				left_sep = {
					str = ' ',
					hl = {
						fg = 'green',
						bg = 'black'
					}
				},
				hl = function()
					local val = {}
					val.name = vi_mode_utils.get_vim_mode()
					val.fg = vi_mode_utils.get_mode_color()
					val.style = 'bold'
					return val
				end,
			},
			{
				provider = 'file_info',
				hl = {
					fg = 'white',
					bg = 'oceanblue',
					style = 'bold'
				},
				left_sep = {
					' ', 'slant_left_2',
					{str = ' ', hl = {bg = 'oceanblue', fg = 'NONE'}}
				},
				right_sep = {'slant_right_2', ' '}
			},
			{
				provider = 'file_size',
				enabled = function() return fn.getfsize(fn.expand('%:p')) > 0 end,
				right_sep = {
					' ',
					{
						str = 'slant_left_2_thin',
						hl = {
							fg = 'fg',
							bg = 'bg'
						}
					},
				}
			},
			{
				provider = 'position',
				left_sep = ' ',
				right_sep = {
					{
						str = 'slant_right_2_thin',
						hl = {
							fg = 'fg',
							bg = 'bg'
						}
					}
				}
			},
			{
				provider = 'lsp_client_names',
				left_sep = ' ',
				icon = '   ',
				hl = {
					fg = '#e0af68'
				},
				right_sep = ' ',
			},
			{
				provider = function ()
					return gps.get_location()
				end,
				enabled = function ()
					return gps.is_available()
				end
			},
			{
				provider = function()
					return package.get_status()
				end,
				hl = {
					style = "bold",
				},
				left_sep = "  ",
				right_sep = " ",
			},
			{
				provider = 'diagnostic_errors',
				enabled = function() return lsp.diagnostics_exist('Error') end,
				hl = { fg = 'red' }
			},
			{
				provider = 'diagnostic_warnings',
				enabled = function() return lsp.diagnostics_exist('Warn') end,
				hl = { fg = 'yellow' }
			},
			{
				provider = 'diagnostic_hints',
				enabled = function() return lsp.diagnostics_exist('Hint') end,
				hl = { fg = 'cyan' }
			},
			{
				provider = 'diagnostic_info',
				enabled = function() return lsp.diagnostics_exist('Info') end,
				hl = { fg = 'skyblue' }
			},
		},
		{},
		{
			{
				provider = 'file_type',
			},
			{
				provider = 'file_encoding',
				left_sep = {
					str = '  ',
					hl = {
						fg = 'white',
						bg = 'black'
					}
				},
			},
			{
				provider = 'git_branch',
				enabled = function() return git_branch({}) ~= '' end,
				hl = {
					fg = 'white',
					bg = 'black',
					style = 'bold'
				},
				left_sep = {
					str = ' ',
					hl = {
						fg = 'white',
						bg = 'black'
					}
				},
			},
			{
				provider = 'git_diff_added',
				enabled = function() return git_branch({}) ~= '' end,
				hl = {
					fg = 'green',
					bg = 'black'
				},
			},
			{
				provider = 'git_diff_changed',
				hl = {
					fg = 'orange',
					bg = 'black'
				}
			},
			{
				provider = 'git_diff_removed',
				hl = {
					fg = 'red',
					bg = 'black'
				},
			},
			{
				provider = 'line_percentage',
				hl = {
					style = 'bold'
				},
				left_sep = {
					str = '  ',
					hl = {
						fg = 'white',
						bg = 'black'
					}
				},
				right_sep = ' '
			},
			{
				provider = 'scroll_bar',
				hl = {
					fg = 'skyblue',
					style = 'bold'
				}
			},
			{
				provider = 'battery',
				hl = {
					fg = 'black',
					bg = 'white',
				},
				left_sep = {
					str = ' ',
					hl = {
						bg = 'black',
						fg = 'white',
					},
				},
			},
			{
				provider = 'os_type',
				hl = {
					fg = 'black',
					bg = 'white',
				},
				right_sep = {
					str = ' ',
					hl = {
						bg = 'black',
						fg = 'white',
					},
				},
			},
		}
	},
	inactive = {
		{
			{
				provider = 'file_type',
				hl = {
					fg = 'white',
					bg = 'oceanblue',
					style = 'bold'
				},
				left_sep = {
					str = ' ',
					hl = {
						fg = 'NONE',
						bg = 'oceanblue'
					}
				},
				right_sep = {
					{
						str = ' ',
						hl = {
							fg = 'NONE',
							bg = 'oceanblue'
						}
					},
					'slant_right'
				}
			},
		},
		{},
		{
			{
				provider = 'battery',
				hl = {
					fg = 'black',
					bg = 'white',
				},
				left_sep = {
					str = ' ',
					hl = {
						bg = 'black',
						fg = 'white',
					},
				},
			},
			{
				provider = 'os_type',
				hl = {
					fg = 'black',
					bg = 'white',
				},
				right_sep = {
					str = ' ',
					hl = {
						bg = 'black',
						fg = 'white',
					},
				},
			},
		},
	},
}

properties.force_inactive.filetypes = {
	'nerdtree',
	'NvimTree',
	'dbui',
	'packer',
	'startify',
	'fugitive',
	'fugitiveblame'
}

properties.force_inactive.buftypes = {
	'terminal',
}

-- This table is equal to the default colors table
local colors = {
	black = '#1B1B1B',
	skyblue = '#50B0F0',
	cyan = '#009090',
	green = '#60A040',
	oceanblue = '#0066cc',
	magenta = '#C26BDB',
	orange = '#FF9000',
	red = '#D10000',
	violet = '#9E93E8',
	white = '#FFFFFF',
	yellow = '#E1E120'
}

-- This table is equal to the default separators table
local separators = {
	vertical_bar = '┃',
	vertical_bar_thin = '│',
	left = '',
	right = '',
	block = '█',
	left_filled = '',
	right_filled = '',
	slant_left = '',
	slant_left_thin = '',
	slant_right = '',
	slant_right_thin = '',
	slant_left_2 = '',
	slant_left_2_thin = '',
	slant_right_2 = '',
	slant_right_2_thin = '',
	left_rounded = '',
	left_rounded_thin = '',
	right_rounded = '',
	right_rounded_thin = '',
	circle = '●'
}

-- This table is equal to the default vi_mode_colors table
local vi_mode_colors = {
	NORMAL = 'green',
	OP = 'green',
	INSERT = 'red',
	VISUAL = 'skyblue',
	BLOCK = 'skyblue',
	REPLACE = 'violet',
	['V-REPLACE'] = 'violet',
	ENTER = 'cyan',
	MORE = 'cyan',
	SELECT = 'orange',
	COMMAND = 'green',
	SHELL = 'green',
	TERM = 'green',
	NONE = 'yellow'
}

require('feline').setup(
	{
		default_bg = '#1F1F23',
		default_fg = '#D0D0D0',
		colors = colors,
		separators = separators,
		components = components,
		properties = properties,
		vi_mode_colors = vi_mode_colors
	}
)
