if exists('g:loaded_pyclewn_configs')
	finish
endif
let g:pyclewn_configs = 1

echom "Bla"

function! s:GetAllConfigsInPath(path, prefix)
	let l:configFiles = []
	for file in split(globpath(a:path, a:prefix . '*.cfg'), '\n')
		call add(l:configFiles, fnamemodify(file, ':t:r'))
	endfor
	return l:configFiles
endfunction

