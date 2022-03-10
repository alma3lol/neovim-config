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
        },
        command_palette = {
          {"File",
            { "entire selection (C-a)", ':call feedkeys("GVgg")' },
            { "save current file (C-s)", ':w' },
            { "save all files (C-A-s)", ':wa' },
            { "quit (C-q)", ':qa' },
            { "file browser (C-i)", ":lua require'telescope'.extensions.file_browser.file_browser()", 1 },
            { "search word (A-w)", ":lua require('telescope.builtin').live_grep()", 1 },
            { "git files (A-f)", ":lua require('telescope.builtin').git_files()", 1 },
            { "files (C-f)",     ":lua require('telescope.builtin').find_files()", 1 },
          },
          {"Help",
            { "tips", ":help tips" },
            { "cheatsheet", ":help index" },
            { "tutorial", ":help tutor" },
            { "summary", ":help summary" },
            { "quick reference", ":help quickref" },
            { "search help(F1)", ":lua require('telescope.builtin').help_tags()", 1 },
          },
          {"Vim",
            { "reload vimrc", ":source $MYVIMRC" },
            { 'check health', ":checkhealth" },
            { "jumps (Alt-j)", ":lua require('telescope.builtin').jumplist()" },
            { "commands", ":lua require('telescope.builtin').commands()" },
            { "command history", ":lua require('telescope.builtin').command_history()" },
            { "registers (A-e)", ":lua require('telescope.builtin').registers()" },
            { "colorshceme", ":lua require('telescope.builtin').colorscheme()", 1 },
            { "vim options", ":lua require('telescope.builtin').vim_options()" },
            { "keymaps", ":lua require('telescope.builtin').keymaps()" },
            { "buffers", ":Telescope buffers" },
            { "search history (C-h)", ":lua require('telescope.builtin').search_history()" },
            { "paste mode", ':set paste!' },
            { 'cursor line', ':set cursorline!' },
            { 'cursor column', ':set cursorcolumn!' },
            { "spell checker", ':set spell!' },
            { "relative number", ':set relativenumber!' },
            { "search highlighting (F12)", ':set hlsearch!' },
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
require('telescope').load_extension('command_palette')
