syntax on
let $CWD=expand("<sfile>:p:h")
let $undoDir=stdpath('data')."/undodir"

"""""""""""""""""""""""""""""""""""""""""""
" This section is for installing vim-plug "
"""""""""""""""""""""""""""""""""""""""""""
let $vimPlugPath=stdpath('data')."/site/autoload/plug.vim"
if !filereadable(expand("$vimPlugPath"))
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
    echom "Vim-plug installed successfuly.\n\nRestart vim/neovim."
    q
endif

set ff=unix
set modelines=0
set wrap
set pastetoggle=<F2>
set formatoptions=tcqrn1
set noerrorbells
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=5
set backspace=indent,eol,start
set ttyfast
set laststatus=2
set showmode
set showcmd
set matchpairs+=<:>
set list
set listchars=tab:>\ ,trail:*,extends:#,nbsp:.
set number
set encoding=utf-8
set hlsearch
set incsearch
set ignorecase
set smartcase
set viminfo='100,<9999,s100
set noswapfile
set nobackup
set undodir=$undoDir
set undofile
set smartindent
set termguicolors
set guicursor=
set relativenumber
set nohlsearch
set scrolloff=8
set noshowmode
set cmdheight=2
set nocompatible
set hidden

so $CWD/plugins.vim

if !filereadable(expand("$CWD/plugged/telescope.nvim/README.MD"))
    PlugInstall --sync
endif
colorscheme cobalt2
let g:dashboard_default_executive = 'telescope'
lua require'terminal'.setup()

so $CWD/airline.vim
so $CWD/bindings.vim
so $CWD/bufbuild.vim
so $CWD/compe.vim
luafile $CWD/lua/compe-config.lua
luafile $CWD/lua/dap-config.lua
so $CWD/denite.vim
so $CWD/emmet.vim
so $CWD/whichkey.vim
so $CWD/floaterm.vim
luafile $CWD/functions.lua
luafile $CWD/lua/functions.lua
luafile $CWD/lua/lsp-config.lua
luafile $CWD/lua/lspsaga-config.lua
so $CWD/signify.vim
so $CWD/sneak.vim
so $CWD/syntastic.vim
so $CWD/telescope.vim
luafile $CWD/lua/telescope.lua
luafile $CWD/lua/treesitter.lua
so $CWD/vsnips.vim
