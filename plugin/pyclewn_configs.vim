if exists('g:loaded_pyclewn_configs')
	finish
endif
let g:pyclewn_configs = 1

echom "Bla"

function! s:GetAllConfigFilesInPath(path)
	echom "bla"
	let l:configFiles = split(globpath(path, '*.cfg'), '\n')
	echom l:configFiles
	return l:configFiles
endfunction

autocmd VimEnter * call s:GetAllConfigFilesInPath()
