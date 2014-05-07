if exists('g:loaded_pyclewn_configs')
	finish
endif
let g:pyclewn_configs = 1

command! -nargs=1 -complete=customlist,s:FileCompletion StartPyclewn :call s:StartDebugging("<args>")

function! s:GetAllConfigsInPath(path, prefix)
	let l:configFiles = []
	for file in split(globpath(a:path, a:prefix . '*.cfg'), '\n')
		call add(l:configFiles, fnamemodify(file, ':t:r'))
	endfor
	return l:configFiles
endfunction

function! s:FileCompletion(ArgLead, CmdLine, CursorPos)
	return s:GetAllConfigsInPath('/home/blibert/.vim/pyclewn_configs/', a:ArgLead)
endfunction

function! s:ReplacePrefix(value, prefix, replacement)
	return substitute(a:value, a:prefix, a:replacement, '')
endfunction

function! s:StartDebugging(configName)
	 let l:path = '/home/blibert/.vim/pyclewn_configs/' . a:configName . '.cfg'
	 let l:ini_result = IniParser#Read(l:path)
	 execute ':Pyclewn'
	 execute ':Cfile ' . l:ini_result['mandatory']['executable']
	 execute ':Cmapkeys'
endfunction

