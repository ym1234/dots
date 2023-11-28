command! -nargs=1 -bang Cscope call  Cscope(<f-args>, expand('<cword>'), <bang>0)
function! Cscope(option, query, bang)
	if empty(a:query)
		echom "Query can't be an empty string"
		return 0
	endif

	if !filereadable('cscope.out')
		echom "Couldn't find cscope.out in pwd"
		return 0
	endif

	" TODO(ym): Change the colors
	let color = '{ x = $1; $1 = ""; $2 = ""; z = $3; $3 = ""; printf "\033[34m%s\033[0m:\033[31m%s:\033[0m%s\033[0m\n", x, z, $0; }'
	call fzf#vim#grep("cscope -dL" . a:option . " " . a:query . " | awk '" . color . "'", 1, fzf#vim#with_preview('down:90%', '?'), a:bang)
endfunction

command! -nargs=1 -bang CscopeQuery call CscopeQuery(<f-args>, <bang>0)
function! CscopeQuery(option, bang)
	let stuff = {
		\ 0: 'C Symbol: ',
		\ 1: 'Definition: ' ,
		\ 2: 'Functions called by: ',
		\ 3: 'Functions calling: ',
		\ 9: 'Assignments to: '
		\}

	let out = get(stuff, a:option, 0)
	if out == 0
		echo out
		return
	endif

	call inputsave()
	let query = input(out)
	call inputrestore()

	if query != ""
		call Cscope(a:option, query, a:bang)
	else
		echom "Cancelled Search!"
	endif
endfunction

autocmd Filetype c nnoremap <buffer> gd :Cscope 1<CR>
autocmd Filetype c nnoremap <buffer> <leader>a :FS<CR>
" setlocal cscopeverbose cscopetag
