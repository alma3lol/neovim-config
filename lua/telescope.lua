-- Credits: ThePrimeagen

local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        layout_config = {
            prompt_position = "top",
        },
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = ' > ',
        color_devicons = true,
        sorting_strategy = "ascending",
        path_display = {
            'shorten',
        },
        set_env = { ['COLORTERM'] = 'truecolor'  },
        file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        mappings = {
            i = {
                ["<Esc>"] = actions.close,
                ["<C-c>"] = false,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
        media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf"},
            find_cmd = "rg"
        },
        frecency = {
            show_scores = true,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
            disable_devicons = false,
            workspaces = {
                ["conf"] = vim.env.CWD,
                ["work"] = vim.env.WORK
            }
        },
        file_browser = {
            them = 'ivy',
            mappings = {
                i = {
                    ["<Esc>"] = actions.close,
                    ["<C-c>"] = false,
                },
            }
        }
    }
}

require('telescope').load_extension('fzy_native')
require('telescope').load_extension('media_files')
require('telescope').load_extension('dap')
require('telescope').load_extension('project')
require('telescope').load_extension('lsp_handlers')
require("telescope").load_extension("emoji")
require("telescope").load_extension("tmux")
require("telescope").load_extension("frecency");
require('telescope').load_extension('neoclip');
require('telescope').load_extension('file_browser');
require("telescope").load_extension("session-lens")
