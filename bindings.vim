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
" Normal, Visual, Select, Operator-pending modes bindings
"
map <C-e> :Telescope file_browser hidden=true<CR>
map <C-h> :SidewaysLeft<CR>
map <C-l> :SidewaysRight<CR>
map <C-k>s :wa<CR>
map <C-k>w :bufdo bd<CR>

map <leader>of :e <C-R>=expand("<cfile>")<CR><CR>
map <leader>ocd :Telescope file_browser hidden=true cwd=<C-R>=expand('%:p:h')<CR><CR>

map <leader>rr :lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>:e<CR>
map <leader>ii :LspInfo<CR>

map gh :call v:lua.HoverInfo()<CR>
map gr :Telescope lsp_references<CR>
map <leader>vdw :vs<CR>:lua vim.lsp.buf.definition()<CR>:sleep 100ms<CR>:wincmd h<CR>
map <silent> g0 :Telescope lsp_document_symbols<CR>
map <silent> gW :Telescope lsp_workspace_symbols query=<C-R>=expand("<cword>")<CR><CR>
map <leader>fiw :vimgrep <C-R>=expand("<cword>")<CR> %<CR>
map <leader>fip :call FindInProjectQuickFixList()<CR>
map <leader><leader>fm :%s/\r//g<CR>
map <leader>qk :cprevious<CR>
map <leader>qj :lnext<CR>
map <leader>qb :cprevious<CR>
map <leader>qn :cnext<CR>
map <leader>qq :call QuickFixToggle()<CR>

map <leader>1 :bN<CR>
map <leader>2 :bn<CR>
map <leader>3 #
map <leader>4 $
map <leader>5 %
map <leader>6 ^
map <leader>7 &
map <leader>8 *
map <leader><leader>1 :q<CR>
map <leader><leader>2 :e $CWD/init.vim<CR>
map <leader><leader>5 :so $CWD/init.vim<CR>

map <leader>ft :Telescope filetypes<CR>
map <leader>sf :call SourceCurrentFile()<CR>
map <leader>fw :Telescope grep_string search=<C-R>=expand("<cword>")<CR><CR>
map <leader>fs :Telescope live_grep<CR>
map <leader>fh :Telescope help_tags<CR>
map <leader>fhw :h <C-R>=expand("<cword>")<CR><CR>
map <leader>fm :Telescope marks<CR>
map <leader>ff :Telescope find_files hidden=true<CR>
map <leader>fd :Telescope file_browser cwd=$CWD hidden=true<CR>
map <leader>fe :Telescope file_browser hidden=true<CR>
map <leader>fb :Telescope buffers<CR>
map <leader>fr :Telescope lsp_references<CR>
map <leader>fds :Telescope lsp_document_symbols<CR>
map <leader>fws :Telescope lsp_workspace_symbols<CR>
map <leader>bb :Telescope buffers<CR>
map <leader>cs :Telescope colorscheme<CR>
map <leader>cw :Windows<CR>

map <leader><leader>p :Telescope project<CR>

map <leader>sa :wa<CR>
map <leader>ss :Startify<CR>

map <leader>pp :VsnipOpen<CR>
map <leader>nn :NERDTreeToggle<CR>

map <leader>m1 `1
map <leader><leader>m1 m1
map <leader>m2 `2
map <leader><leader>m2 m2
map <leader>m3 `3
map <leader><leader>m3 m3
map <leader>m4 `4
map <leader><leader>m4 m4

map <leader>gf :Telescope git_files<CR>
map gb :Git blame<CR>
map <leader>gy ggyG<CR>
map <leader>g= gg=G<CR>
map <leader>gd ggdG<CR>

map <silent> <leader>ct :call GenerateCTagsForCurrentFile()<CR><CR>
map <silent> <leader>vt :execute 'Telescope tags ctags_file='..$CTAGS_DIR..UrlEncode(expand('%:p'))<CR>

map <leader>d. dt.
map <leader>d, dt,
map <leader>d' dt'
map <leader>d" dt"
map <leader>d` dt`
map <leader><leader>d' di'
map <leader><leader>d" di"
map <leader><leader>d` di`
map <leader>d9 di(
map <leader>d0 dt)
map <leader>d[ di[
map <leader>d] dt]
map <leader>d{ di{
map <leader>d} dt}
map <leader>d; dt;
map <leader>d4 d$
map <leader>d5 di%
map <leader>d6 d^

map <leader>c. ct.
map <leader>c, ct,
map <leader>c' ct'
map <leader>c" ct"
map <leader>c` ct`
map <leader><leader>c' ci'
map <leader><leader>c" ci"
map <leader><leader>c` ci`
map <leader>c9 ci(
map <leader>c0 ct)
map <leader>c[ ci[
map <leader>c] ct]
map <leader>c{ ci{
map <leader>c} ct}
map <leader>c; ct;
map <leader>c4 c$
map <leader>c5 ci%
map <leader>c6 c^

map <leader>y. yt.
map <leader>y, yt,
map <leader>y' yt'
map <leader>y" yt"
map <leader>y` yt`
map <leader><leader>y' yi'
map <leader><leader>y" yi"
map <leader><leader>y` yi`
map <leader>y9 yi(
map <leader>y0 yt)
map <leader>y[ yi[
map <leader>y] yt]
map <leader>y{ yi{
map <leader>y} yt}
map <leader>y; yt;
map <leader>y4 y$
map <leader>y5 yi%
map <leader>y6 y^

map <leader>bd :bd<CR>
map <leader>xbd :bd!<CR>
map <leader>bn :ene<CR>

map <leader>w :w<CR>
map <leader>xw :w!<CR>
map <leader>vw :vs<CR>
map <leader>nvw :sp<CR>
map <leader>nt :tab split<CR>

map <leader>ys :FloatermNew yarn start<CR>
map <leader>yb :FloatermNew yarn build<CR>
map <leader>yt :FloatermNew yarn test<CR>
map <leader>yd :FloatermNew yarn debug<CR>
map <leader>df :FloatermNew node --inspect %<CR>

map <leader>h :wincmd h<CR>
map <leader>j :wincmd j<CR>
map <leader>k :wincmd k<CR>
map <leader>l :wincmd l<CR>

map <leader>mm :MaximizerToggle<CR>
map <leader>u :UndotreeToggle<CR>

map <leader><leader>ww :Windows<CR>
map <leader><leader>w= :wincmd =<CR>
map <leader>o :on<CR>
map <leader>ow :on<CR>
map <leader>ot :tabonly<CR>

map <C-Left> :tabprevious<CR>
map <C-Right> :tabnext<CR>
nnoremap <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

map <leader><leader>v V

map <leader>tt :FloatermToggle<CR>
map <leader>tg :FloatermNew lazygit<CR>
map <leader>tb :TagbarToggle<CR>
map <leader>ts :Telescope tmux sessions<CR>
map <leader>tw :Telescope tmux windows<CR>
map <leader>tp :Telescope tmux pane_contents<CR>

map <leader>db :Denite -auto-resize buffer<CR>
map <leader>dh :Denite -auto-resize help<CR>
map <leader>dm :Denite -auto-resize mark<CR>
map <leader>do :Denite -auto-resize outline<CR>
map <leader>dr :Denite -auto-resize register<CR>

map <leader>du :lua require("dapui").toggle()<CR>
map <silent> <F5> :lua require'dap'.continue()<CR>
map <silent> <F10> :lua require'dap'.step_over()<CR>
map <silent> <F11> :lua require'dap'.step_into()<CR>
map <silent> <F12> :lua require'dap'.step_out()<CR>
map <silent> <F9> :lua require'dap'.toggle_breakpoint()<CR>
map <silent> bl :lua require'dap'.list_breakpoints()<CR>
map <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
map <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
map <silent> <leader>bl :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
map <silent> <leader>ro :lua require'dap'.repl.open()<CR>
map <silent> <leader>rl :lua require'dap'.run_last()<CR>

"
" Normal mode bindings
"
nmap <F2> :set invpaste paste?<CR><CR>
nmap <leader>vp V}
nmap <leader>vb <C-V>}
nmap <C-/> vgc
nmap <leader>/ vgc
nmap <leader> :silent WhichKey '<Space>'<CR>
nmap <leader>sl :call SourceCurrentLine()<CR>
nmap <leader>ca :Lspsaga code_action<CR>
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
"
"
" Visual mode bindings
"
vmap <C-/> gc
vmap <leader>/ vgc
vmap <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>
vmap <leader>s' S'
vmap <leader>s" S"
vmap <leader>s` S`
vmap <leader>s{ S{
vmap <leader>s[ S[
vmap <leader>s( S(
vmap <leader>sl :<C-w>call SourceSelectedLines()<CR>
vmap <leader>ca :<C-U>Lspsaga range_code_action<CR>

"
" Insert mode bindings
"
imap <F2> <C-O>:set invpaste paste?<CR><CR>
imap <leader><leader><Backspace> <Esc>v^c
imap <leader>tt <Esc>:FloatermToggle<CR>
imap <leader><leader>o <Esc>o
imap <leader><leader>no <Esc>O
imap <leader><leader>p <Esc>pa
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
