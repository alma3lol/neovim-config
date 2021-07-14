let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
	\| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Register which key map
call which_key#register('<leader>', "g:which_key_map")
