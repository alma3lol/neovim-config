syntax on
let $CWD=expand("<sfile>:p:h")

let $CWF=expand("%:p:h")

set completeopt=menu,menuone,noselect
set ff=unix
set mouse=a
set modelines=0
set wrap
set pastetoggle=<F2>
set formatoptions=tcqrn1
set noerrorbells
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set noexpandtab
set noshiftround
set scrolloff=5
set backspace=indent,eol,start
set ttyfast
set laststatus=2
set showcmd
set matchpairs+=<:>
set list
set listchars=tab:>\ ,trail:*,extends:#,nbsp:.,eol:↴,space:·
set number
set encoding=utf-8
set incsearch
set ignorecase
set smartcase
set viminfo='100,<9999,s100
set undodir=$CWD/undodir//
set backupdir=$CWD/backup//
set directory=$CWD/directory//
set undofile
set swapfile
set backup
set smartindent
set termguicolors
set relativenumber
set nohlsearch
set scrolloff=8
set noshowmode
set cmdheight=2
set nocompatible
set hidden
set sessionoptions+=winpos,terminal
set cursorline
set foldenable
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldnestmax=1

if !isdirectory(expand("$CWD/backup"))
    silent call system(expand("mkdir $CWD/backup")) | redraw!
endif

"""""""""""""""""""""""""""""""""""""""""""
" This section is for installing vim-plug "
"""""""""""""""""""""""""""""""""""""""""""
let $nvimPluginsAutoloadPath=stdpath('data')."/site/autoload"
call mkdir(expand($nvimPluginsAutoloadPath), "p")
let $vimPlugPath=$nvimPluginsAutoloadPath."/plug.vim"
let s:vimPlugJustInstalled = v:false
if !filereadable(expand("$vimPlugPath"))
    s:vimPlugJustInstalled = v:true
    echom "Installing Vim-plug...\n"
    if has('win32')
        if executable('curl')
            !curl -s -o $vimPlugPath "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        elseif executable('wget')
            !wget -o $vimPlugPath "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        els
            !powershell -w 0 -ep bypass -e "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni \"".$vimPlugPath."\""
        endif
    else
        if executable('curl')
            !curl -s -o $vimPlugPath "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        else
            !wget -o $vimPlugPath "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
        endif
    endif
    echom "Vim-plug installed successfuly."
    so $vimPlugPath
    PlugInstall --sync | close
endif

so $VIMRUNTIME/plugin/rplugin.vim
so $CWD/plugins.vim

let $colorschemeSet = exists('$colorschemeSet') ? v:true : v:false
if ($colorschemeSet == v:false)
    lua vim.g.tokyonight_style = "night"
    colorscheme tokyonight
    let $colorschemeSet=v:true
endif

" autocmd VimEnter * PlugClean! | PlugUpdate --sync | close

let g:instant_username = "Alma3lol"

if !isdirectory(expand("$CWD/vscode-firefox-debug"))
    cd $CWD
    echo "Installing vscode-firefox-debug..."
    !git clone https://github.com/firefox-devtools/vscode-firefox-debug.git
    cd vscode-firefox-debug
    !npm i
    !npm run build
    cd $CWF
endif
if !isdirectory(expand("$CWD/vscode-chrome-debug"))
    cd $CWD
    echo "Installing vscode-chrome-debug..."
    !git clone https://github.com/microsoft/vscode-chrome-debug.git
    cd vscode-chrome-debug
    !npm i
    !npm run build
    cd $CWF
endif
if !isdirectory(expand("$CWD/vscode-node-debug2"))
    cd $CWD
    echo "Installing vscode-node-debug2..."
    !git clone https://github.com/microsoft/vscode-node-debug2.git
    cd vscode-node-debug2
    !npm i
    !npx gulp build
    cd $CWF
endif
if !isdirectory(expand("$CWD/lua-language-server"))
    cd $CWD
    echo "Installing lua-language-server..."
    !git clone https://github.com/sumneko/lua-language-server
    cd lua-language-server
    !git submodule update --init --recursive
    cd 3rd/luamake
    if has('win32')
        !compile\install.bat
    else
        !bash compile/install.sh
    endif
    cd ../..
    if has('win32')
        !3rd\luamake\luamake.exe rebuild
    else
        !3rd/luamake/luamake rebuild
    endif
    cd $CWF
endif
let g:dashboard_default_executive = 'telescope'
lua require'terminal'.setup()

luafile $CWD/lua/autosession.lua
so $CWD/bufbuild.vim
so $CWD/bindings.vim
so $CWD/compe.vim
luafile $CWD/lua/bufferline.lua
luafile $CWD/lua/commment.lua
luafile $CWD/lua/compe-config.lua
luafile $CWD/lua/neoclip.lua
luafile $CWD/lua/neorg.lua
luafile $CWD/lua/dap-config.lua
luafile $CWD/lua/dap-ui-config.lua
luafile $CWD/lua/dap-virtual-text.lua
so $CWD/denite.vim
so $CWD/emmet.vim
so $CWD/whichkey.vim
so $CWD/floaterm.vim
luafile $CWD/lua/feline-providers.lua
luafile $CWD/lua/feline.lua
luafile $CWD/lua/functions.lua
luafile $CWD/lua/gitsigns.lua
luafile $CWD/lua/gps.lua
luafile $CWD/lua/indent_blankline.lua
luafile $CWD/lua/lsp-format.lua
luafile $CWD/lua/lsp-config.lua
luafile $CWD/lua/lspsaga-config.lua
luafile $CWD/lua/lsp-installer.lua
luafile $CWD/lua/octo.lua
luafile $CWD/lua/package-info.lua
luafile $CWD/lua/session-lens.lua
so $CWD/signify.vim
so $CWD/sneak.vim
so $CWD/syntastic.vim
so $CWD/telescope.vim
luafile $CWD/lua/telescope.lua
luafile $CWD/lua/treesitter.lua
luafile $CWD/lua/treesitter-context.lua
luafile $CWD/lua/trouble.lua
luafile $CWD/lua/toggleterm.lua
luafile $CWD/lua/twilight.lua
so $CWD/vsnips.vim
luafile $CWD/lua/zenmode.lua

highlight link LspSagaFinderSelection Search
let test#strategy = "neovim"

augroup LuaHighlight
    au!
    au TextYankPost * lua vim.highlight.on_yank {
                \ higroup = "Substitute",
                \ timeout = 150,
                \ on_macro = true
                \ }
augroup END

autocmd vimEnter * hi Normal guibg=NONE ctermbg=NONE
