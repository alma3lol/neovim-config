let mapleader=" "

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

"
" Normal mode bindings
"
nnoremap <C-e> :Telescope file_browser hidden=true<CR>
nnoremap <C-h> :SidewaysLeft<CR>
nnoremap <C-l> :SidewaysRight<CR>
nnoremap <C-k>s :wa<CR>
nnoremap <C-k>w :bufdo bd<CR>

nnoremap <leader>of :e <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>ocd :Telescope file_browser hidden=true cwd=<C-R>=expand('%:p:h')<CR><CR>

nnoremap <leader>rr :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>:e<CR>
nnoremap <leader>ii :LspInfo<CR>

nnoremap gh :call v:lua.HoverInfo()<CR>
nnoremap gr :Telescope lsp_references<CR>
nnoremap <leader>vdw :vs<CR>:lua vim.lsp.buf.definition()<CR>:sleep 100ms<CR>:wincmd h<CR>
nnoremap <silent> g0 :Telescope lsp_document_symbols<CR>
nnoremap <silent> gW :Telescope lsp_workspace_symbols query=<C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fiw :vimgrep <C-R>=expand("<cword>")<CR> %<CR>
nnoremap <leader>fip :call FindInProjectQuickFixList()<CR>
nnoremap <leader><leader>fm :%s/\r//g<CR>
nnoremap <leader>qk :lprevious<CR>
nnoremap <leader>qj :lnext<CR>
nnoremap <leader>qb :cprevious<CR>
nnoremap <leader>qn :cnext<CR>
nnoremap <leader>qq :call QuickFixToggle()<CR>

nnoremap <leader>1 :bN<CR>
nnoremap <leader>2 :bn<CR>
nnoremap <leader>3 #
nnoremap <leader>4 $
nnoremap <leader>5 %
nnoremap <leader>6 ^
nnoremap <leader>7 &
nnoremap <leader>8 *
nnoremap <leader><leader>1 :q<CR>
nnoremap <leader><leader>2 :e $CWD/init.vim<CR>
nnoremap <leader><leader>5 :so $CWD/init.vim<CR>

nnoremap <leader>ft :Telescope filetypes<CR>
nnoremap <leader>sf :call SourceCurrentFile()<CR>
nnoremap <leader>fw :Telescope grep_string search=<C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fs :Telescope live_grep<CR>
nnoremap <leader>fh :Telescope help_tags<CR>
nnoremap <leader>fhw :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>fm :Telescope marks<CR>
nnoremap <leader>ff :Telescope find_files hidden=true<CR>
nnoremap <leader>fd :Telescope file_browser cwd=$CWD hidden=true<CR>
nnoremap <leader>fe :Telescope file_browser hidden=true<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fr :Telescope lsp_references<CR>
nnoremap <leader>fds :Telescope lsp_document_symbols<CR>
nnoremap <leader>fws :Telescope lsp_workspace_symbols<CR>
nnoremap <leader>bb :Telescope buffers<CR>
nnoremap <leader>cs :Telescope colorscheme<CR>
nnoremap <leader>cw :Windows<CR>

nnoremap <leader><leader>p :Telescope project<CR>

nnoremap <leader>sa :wa<CR>
nnoremap <leader>ss :Startify<CR>

nnoremap <leader>pp :VsnipOpen<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>

nnoremap <leader>m1 `1
nnoremap <leader><leader>m1 m1
nnoremap <leader>m2 `2
nnoremap <leader><leader>m2 m2
nnoremap <leader>m3 `3
nnoremap <leader><leader>m3 m3
nnoremap <leader>m4 `4
nnoremap <leader><leader>m4 m4

nnoremap <leader>gf :Telescope git_files<CR>
nnoremap gb :Git blame<CR>
nnoremap <leader>gy ggyG<CR>
nnoremap <leader>g= gg=G<CR>
nnoremap <leader>gd ggdG<CR>

nnoremap <silent> <leader>ct :call GenerateCTagsForCurrentFile()<CR><CR>
nnoremap <silent> <leader>vt :execute 'Telescope tags ctags_file='..$CTAGS_DIR..UrlEncode(expand('%:p'))<CR>

nnoremap <leader>d. dt.
nnoremap <leader>d, dt,
nnoremap <leader>d' dt'
nnoremap <leader>d" dt"
nnoremap <leader>d` dt`
nnoremap <leader><leader>d' di'
nnoremap <leader><leader>d" di"
nnoremap <leader><leader>d` di`
nnoremap <leader>d9 di(
nnoremap <leader>d0 dt)
nnoremap <leader>d[ di[
nnoremap <leader>d] dt]
nnoremap <leader>d{ di{
nnoremap <leader>d} dt}
nnoremap <leader>d; dt;
nnoremap <leader>d4 d$
nnoremap <leader>d5 di%
nnoremap <leader>d6 d^

nnoremap <leader>c. ct.
nnoremap <leader>c, ct,
nnoremap <leader>c' ct'
nnoremap <leader>c" ct"
nnoremap <leader>c` ct`
nnoremap <leader><leader>c' ci'
nnoremap <leader><leader>c" ci"
nnoremap <leader><leader>c` ci`
nnoremap <leader>c9 ci(
nnoremap <leader>c0 ct)
nnoremap <leader>c[ ci[
nnoremap <leader>c] ct]
nnoremap <leader>c{ ci{
nnoremap <leader>c} ct}
nnoremap <leader>c; ct;
nnoremap <leader>c4 c$
nnoremap <leader>c5 ci%
nnoremap <leader>c6 c^

nnoremap <leader>y. yt.
nnoremap <leader>y, yt,
nnoremap <leader>y' yt'
nnoremap <leader>y" yt"
nnoremap <leader>y` yt`
nnoremap <leader><leader>y' yi'
nnoremap <leader><leader>y" yi"
nnoremap <leader><leader>y` yi`
nnoremap <leader>y9 yi(
nnoremap <leader>y0 yt)
nnoremap <leader>y[ yi[
nnoremap <leader>y] yt]
nnoremap <leader>y{ yi{
nnoremap <leader>y} yt}
nnoremap <leader>y; yt;
nnoremap <leader>y4 y$
nnoremap <leader>y5 yi%
nnoremap <leader>y6 y^

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
nnoremap <leader>df :FloatermNew node --inspect %<CR>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

nnoremap <leader>mm :MaximizerToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

nnoremap <leader><leader>ww :Windows<CR>
nnoremap <leader><leader>w= :wincmd =<CR>
nnoremap <leader>o :on<CR>
nnoremap <leader>ow :on<CR>
nnoremap <leader>ot :tabonly<CR>

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

nnoremap <leader><leader>v V

nnoremap <leader>tt :FloatermToggle<CR>
nnoremap <leader>tg :FloatermNew lazygit<CR>
nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>ts :Telescope tmux sessions<CR>
nnoremap <leader>tw :Telescope tmux windows<CR>
nnoremap <leader>tp :Telescope tmux pane_contents<CR>

nnoremap <leader>db :Denite -auto-resize buffer<CR>
nnoremap <leader>dh :Denite -auto-resize help<CR>
nnoremap <leader>dm :Denite -auto-resize mark<CR>
nnoremap <leader>do :Denite -auto-resize outline<CR>
nnoremap <leader>dr :Denite -auto-resize register<CR>

nnoremap <leader>du :lua require("dapui").toggle()<CR>
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
nnoremap <C-/> vgc
nnoremap <leader>/ vgc
nnoremap <leader> :silent WhichKey '<Space>'<CR>
nnoremap <leader>sl :call SourceCurrentLine()<CR>
nnoremap <leader>ca :Lspsaga code_action<CR>
nnoremap <silent>gs :Lspsaga signature_help<CR>
nnoremap <silent>gd :Lspsaga lsp_finder<CR>
nnoremap <silent><C-f> <cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>
nnoremap <silent><C-b> <cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>
nnoremap <silent><leader>rn :Lspsaga rename<CR>
nnoremap <silent><leader>pd :Lspsaga preview_definition<CR>
nnoremap <silent><leader>sd :Lspsaga show_line_diagnostics<CR>
nnoremap <silent>[d :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent>]d :Lspsaga diagnostic_jump_prev<CR>
nnoremap <silent><A-d> :Lspsaga open_floaterm<CR>
nnoremap <silent><leader>gb :BufferLinePick<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

"
"
" Visual mode bindings
"
vnoremap <C-/> gc
vnoremap <leader>/ vgc
vnoremap <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
vnoremap <leader>s' S'
vnoremap <leader>s" S"
vnoremap <leader>s` S`
vnoremap <leader>s{ S{
vnoremap <leader>s[ S[
vnoremap <leader>s( S(
vnoremap <leader>sl :<C-w>call SourceSelectedLines()<CR>
vnoremap <leader>ca :<C-U>Lspsaga range_code_action<CR>

"
" Insert mode bindings
"
inoremap <F2> <C-O>:set invpaste paste?<CR><CR>
inoremap <leader><leader><Backspace> <Esc>v^c
inoremap <leader>tt <Esc>:FloatermToggle<CR>
inoremap <leader><leader>o <Esc>o
inoremap <leader><leader>no <Esc>O
inoremap <leader><leader>p <Esc>pa
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <NULL> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4  })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4  })
inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>

"
" Terminal mode bindings
"
tnoremap <Esc> <C-\><C-n>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
