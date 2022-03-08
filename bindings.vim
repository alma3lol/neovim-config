let $CTAGS_DIR=$CWD..'/ctags/'
call mkdir($CTAGS_DIR, "p")

"
" Functions
"

function! SourceSelectedLines()
	if expand('%:e') ==# 'lua'
		call execute(printf(":lua %s", join(getline("'<","'>"),'<Bar>')))
	else
		execute printf(':exe %s', join(getline("'<","'>"),'<Bar>'))
	endif
endfunction
function! SourceCurrentLine()
	if expand('%:e') ==# 'lua'
		call execute(printf(":lua %s", getline(".")))
	else
		execute getline('>')
	endif
endfunction
if !exists('*SourceCurrentFile')
	function! SourceCurrentFile()
		if expand('%:e') ==# 'lua'
			luafile %
		else
			so %
		endif
	endfunction
endif

function! QuickFixToggle()
	for i in range(1, winnr('$'))
		let bnum = winbufnr(i)
		if getbufvar(bnum, '&buftype') == 'quickfix'
			cclose
			return
		endif
	endfor
	copen
endfunction

function! FindInProjectQuickFixList()
	let find = input("Find in project > ")
	let files = input("Path patternt > ")
	silent! execute 'vimgrep' find files
endfunction

function! UrlEncode(string)
	let result = ""
	let characters = split(a:string, '.\zs')
	for character in characters
		if character == " "
			let result = result . "+"
		elseif CharacterRequiresUrlEncoding(character)
			let i = 0
			while i < strlen(character)
				let byte = strpart(character, i, 1)
				let decimal = char2nr(byte)
				let result = result . "%" . printf("%02x", decimal)
				let i += 1
			endwhile
		else
			let result = result . character
		endif
	endfor
	return result
endfunction

function! CharacterRequiresUrlEncoding(character)
	let ascii_code = char2nr(a:character)
	if ascii_code >= 48 && ascii_code <= 57
		return 0
	elseif ascii_code >= 65 && ascii_code <= 90
		return 0
	elseif ascii_code >= 97 && ascii_code <= 122
		return 0
	elseif a:character == "-" || a:character == "_" || a:character == "." || a:character == "~"
		return 0
	endif
	return 1
endfunction

function! GenerateCTagsForCurrentFile()
	let $currentProjectCTagsFile = getcwd()..'/.ctags'
	if filereadable($currentProjectCTagsFile)
		execute "!ctags -f "..shellescape($CTAGS_DIR..UrlEncode(expand('%:p')), 1)..' --options='..shellescape($currentProjectCTagsFile, 1)..' "%"'
	else
		execute "!ctags -f "..shellescape($CTAGS_DIR..UrlEncode(expand('%:p')), 1)..' "%"'
	endif
endfunction

function! CreateJupyterAscendingNotebook()
	" get a new file name
	let $fileName = input('New notebook name > ')
	if $fileName == ''
		return
	endif
	" get the current directory
	let $currentDirectory = expand('%:p')
	" execute the system command `python -m jupyter_ascending.scripts.make_pair --base $fileName`
	execute "!python -m jupyter_ascending.scripts.make_pair --base "..shellescape($fileName, 1)
endfunction

"
" Default <leader> is <Space>
"
let mapleader=" "

"
" All modes bindings
"
noremap <leader>3 #
noremap <leader>4 $
noremap <leader>5 %
noremap <leader>6 ^
noremap <leader>7 &
noremap <leader>8 *

"
" Normal mode bindings
"
nnoremap <M-h> :SidewaysLeft<CR>
nnoremap <M-l> :SidewaysRight<CR>
nnoremap <C-k>s :wa<CR>
nnoremap <C-k>w :bufdo bd<CR>

nnoremap <leader>of :e <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>cd :lua require 'telescope'.extensions.file_browser.file_browser({ hidden = true, path="<C-R>=expand('%:p:h')<CR>" })<CR>

nnoremap <leader>rr :LspRestart<CR>
nnoremap <leader>ii :LspInfo<CR>

nnoremap gh :call v:lua.HoverInfo()<CR>
nnoremap gr :Telescope lsp_references<CR>
nnoremap <leader>vdw :vs<CR>:lua vim.lsp.buf.definition()<CR>:sleep 100ms<CR>:wincmd h<CR>
nnoremap <leader>fiw :vimgrep <C-R>=expand("<cword>")<CR> %<CR>
nnoremap <leader>fip :call FindInProjectQuickFixList()<CR>
nnoremap <leader><leader>fm :%s/\r//g<CR>
nnoremap <leader>qk :lprevious<CR>
nnoremap <leader>qj :lnext<CR>
nnoremap <leader>qp :cprevious<CR>
nnoremap <leader>qn :cnext<CR>
nnoremap <leader>qq :call QuickFixToggle()<CR>

nnoremap <leader>1 :bN<CR>
nnoremap <leader>2 :bn<CR>
nnoremap <leader><leader>q :q<CR>
nnoremap <leader><leader>1 <CMD>BufferLineGoToBuffer 1<CR>
nnoremap <leader><leader>2 <CMD>BufferLineGoToBuffer 2<CR>
nnoremap <leader><leader>3 <CMD>BufferLineGoToBuffer 3<CR>
nnoremap <leader><leader>4 <CMD>BufferLineGoToBuffer 4<CR>
nnoremap <leader><leader>5 <CMD>BufferLineGoToBuffer 5<CR>
nnoremap <leader><leader>6 <CMD>BufferLineGoToBuffer 6<CR>
nnoremap <leader><leader>7 <CMD>BufferLineGoToBuffer 7<CR>
nnoremap <leader><leader>8 <CMD>BufferLineGoToBuffer 8<CR>
nnoremap <leader><leader>9 <CMD>BufferLineGoToBuffer 9<CR>
nnoremap <leader><leader>sb :so $CWD/bindings.vim<CR>

nnoremap <leader>ft :Telescope filetypes<CR>
nnoremap <leader>sf :call SourceCurrentFile()<CR>
nnoremap <leader>fw :Telescope grep_string search=<C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fs :Telescope live_grep<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <leader>fhw :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fm :Telescope marks<CR>
nnoremap <leader>ff :Telescope find_files hidden=true<CR>
nnoremap <leader>fd :lua require 'telescope'.extensions.file_browser.file_browser({ hidden = true, path=vim.env.CWD })<CR>
nnoremap <leader>fe :lua require 'telescope'.extensions.file_browser.file_browser({ hidden = true })<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fr :Telescope frecency<CR>
nnoremap <leader>fds :Telescope lsp_document_symbols<CR>
nnoremap <leader>fws :Telescope lsp_workspace_symbols<CR>
nnoremap <leader>cs :Telescope colorscheme<CR>
nnoremap <leader><leader>p :Telescope project<CR>
nnoremap <leader>sa :wa<CR>
nnoremap <leader>ss :Startify<CR>
nnoremap <leader>ls :SearchSession<CR>
nnoremap <leader>pp :VsnipOpen<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>
nnoremap <leader>zz :ZenMode<CR>
nnoremap <leader><leader>nr :Telescope neoclip<CR>

nnoremap <leader>gg :G<CR>
nnoremap <leader>gf :Telescope git_files<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gy ggyG<CR>
nnoremap <leader>g= gg=G<CR>
nnoremap <leader>gd ggdG<CR>

nnoremap <silent> <leader>ct :call GenerateCTagsForCurrentFile()<CR><CR>
nnoremap <silent> <leader>vt :execute 'Telescope tags ctags_file='..$CTAGS_DIR..UrlEncode(expand('%:p'))<CR>

nnoremap <leader>c. ct.
nnoremap <leader>c, ct,
nnoremap <leader>c' ct'
nnoremap <leader>c" ct"
nnoremap <leader>c` ct`
nnoremap <leader>c9 ct(
nnoremap <leader>c0 ct)
nnoremap <leader>c[ ct[
nnoremap <leader>c] ct]
nnoremap <leader>c{ ct{
nnoremap <leader>c} ct}
nnoremap <leader>c; ct;
nnoremap <leader>c4 c$
nnoremap <leader>c5 ci%
nnoremap <leader>c6 c^
nnoremap <leader><leader>c' ci'
nnoremap <leader><leader>c" ci"
nnoremap <leader><leader>c` ci`
nnoremap <leader><leader>c9 ci(
nnoremap <leader><leader>c[ ci[
nnoremap <leader><leader>c{ ci{

nnoremap <leader>d. dt.
nnoremap <leader>d, dt,
nnoremap <leader>d' dt'
nnoremap <leader>d" dt"
nnoremap <leader>d` dt`
nnoremap <leader>d9 dt(
nnoremap <leader>d0 dt)
nnoremap <leader>d[ dt[
nnoremap <leader>d] dt]
nnoremap <leader>d{ dt{
nnoremap <leader>d} dt}
nnoremap <leader>d; dt;
nnoremap <leader>d4 d$
nnoremap <leader>d5 di%
nnoremap <leader>d6 d^
nnoremap <leader><leader>d' di'
nnoremap <leader><leader>d" di"
nnoremap <leader><leader>d` di`
nnoremap <leader><leader>d9 di(
nnoremap <leader><leader>d[ di[
nnoremap <leader><leader>d{ di{

nnoremap <leader>y. yt.
nnoremap <leader>y, yt,
nnoremap <leader>y' yt'
nnoremap <leader>y" yt"
nnoremap <leader>y` yt`
nnoremap <leader>y9 yt(
nnoremap <leader>y0 yt)
nnoremap <leader>y[ yt[
nnoremap <leader>y] yt]
nnoremap <leader>y{ yt{
nnoremap <leader>y} yt}
nnoremap <leader>y; yt;
nnoremap <leader>y4 y$
nnoremap <leader>y5 yi%
nnoremap <leader>y6 y^
nnoremap <leader><leader>y' yi'
nnoremap <leader><leader>y" yi"
nnoremap <leader><leader>y` yi`
nnoremap <leader><leader>y9 yi(
nnoremap <leader><leader>y[ yi[
nnoremap <leader><leader>y{ yi{

nnoremap <leader>bd :bd<CR>
nnoremap <leader>xbd :bd!<CR>
nnoremap <leader>bn :ene<CR>

nnoremap <leader>w :w<CR>
nnoremap <leader>xw :w!<CR>
nnoremap <leader>vw :vs<CR>
nnoremap <leader>nvw :sp<CR>
nnoremap <leader>nt :tab split<CR>

nnoremap <leader>ys :FloatermNew yarn start<CR>
nnoremap <leader>yb :FloatermNew yarn build<CR>
nnoremap <leader>yt :FloatermNew yarn test<CR>
nnoremap <leader>yd :FloatermNew yarn debug<CR>

nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>

nnoremap <leader>mm :MaximizerToggle<CR>
nnoremap <leader>uu :UndotreeToggle<CR>
nnoremap <leader>uh :SignifyHunkUndo<CR>

nnoremap <leader><leader>w= :wincmd =<CR>
nnoremap <leader>ow :on<CR>
nnoremap <leader>ot :tabonly<CR>

nnoremap <leader><leader>v V

nnoremap <leader>tt :Twilight<CR>
nnoremap <leader>tg :LazyGit<CR>
nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>ts :Telescope tmux sessions<CR>
nnoremap <leader>tw :Telescope tmux windows<CR>
nnoremap <leader>tp :Telescope tmux pane_contents<CR>
nnoremap <leader>rt :TestFile<CR>

nnoremap <leader>db :Denite -auto-resize buffer<CR>
nnoremap <leader>dh :Denite -auto-resize help<CR>
nnoremap <leader>dm :Denite -auto-resize mark<CR>
nnoremap <leader>do :Denite -auto-resize outline<CR>
nnoremap <leader>dr :Denite -auto-resize register<CR>

nnoremap <silent> <leader>du :lua require("dapui").toggle()<CR>
nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
nnoremap <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> bl :lua require'dap'.list_breakpoints()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>bl :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>ro :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>rl :lua require'dap'.run_last()<CR>

nnoremap <F2> :set invpaste paste?<CR><CR>
nnoremap <leader>vp V}
nnoremap <leader>vb <C-V>}
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <silent> <leader>sl :call SourceCurrentLine()<CR>
nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
nnoremap <silent> <leader>gs :Lspsaga signature_help<CR>
nnoremap <silent> gd :Lspsaga lsp_finder<CR>
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>
nnoremap <silent> <leader>rn :Lspsaga rename<CR>
nnoremap <silent> <leader>pd :Lspsaga preview_definition<CR>
nnoremap <silent> <leader>sd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> [d :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]d :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
nnoremap <silent> <leader>bb :BufferLinePick<CR>
nnoremap <silent> <c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>
nmap <C-/> vgc
nmap <leader>/ vgc

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Show package versions
noremap <silent> <leader>ns :lua require('package-info').show()<CR>

" Hide package versions
noremap <silent> <leader>nc :lua require('package-info').hide()<CR>

" Update package on line
noremap <silent> <leader>nu :lua require('package-info').update()<CR>

" Delete package on line
noremap <silent> <leader>nd :lua require('package-info').delete()<CR>

" Install a new package
noremap <silent> <leader>ni :lua require('package-info').install()<CR>

" Reinstall dependencies
noremap <silent> <leader>nr :lua require('package-info').reinstall()<CR>

" Install a different package version
noremap <silent> <leader>np :lua require('package-info').change_version()<CR>

nnoremap <leader>to :SymbolsOutline<CR>

nnoremap <leader>ha :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>hh :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>hw :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <leader>h1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>h2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>h3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>h4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>

nnoremap <leader><leader>mj :call CreateJupyterAscendingNotebook()<CR>
nmap <leader><leader>x <Plug>JupyterExecute
nmap <leader><leader>X <Plug>JupyterExecuteAll

luafile $CWD/lua/bindings.lua

"
"
" Visual mode bindings
"
vmap <C-/> gc
vmap <leader>/ gc
vnoremap <silent> <leader> :<c-u> :WhichKeyVisual '<Space>'<CR>
vmap <leader>s' S'
vmap <leader>s" S"
vmap <leader>s` S`
vmap <leader>s{ S{
vmap <leader>s[ S[
vmap <leader>s9 S(
vnoremap <leader>sl :<C-w>call SourceSelectedLines()<CR>
vnoremap <leader>ca :<C-U>Lspsaga range_code_action<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"
" Insert mode bindings
"
inoremap <F2> <C-O>:set invpaste paste?<CR><CR>
inoremap <leader><leader><BS> <Esc>v0c
inoremap <leader><leader>o <Esc>o
inoremap <leader><leader>no <Esc>O
inoremap <leader><leader>p <Esc>pa
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <c-j> <esc>:m .+1<CR>==a
inoremap <c-k> <esc>:m .-2<CR>==a

"
" Terminal mode bindings
"
tnoremap <Esc> <C-\><C-n>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>

"
" Maps with comma (,)
"
nnoremap ,f :Telescope current_buffer_fuzzy_find<CR>
nnoremap ,ds :Telescope lsp_document_symbols<CR>
nnoremap ,ws :Telescope lsp_workspace_symbols query=<C-R>=expand("<cword>")<CR><CR>
