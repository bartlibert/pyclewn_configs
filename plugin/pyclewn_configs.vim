if exists('g:loaded_pyclewn_configs')
	finish
endif
let g:pyclewn_configs = 1

command! -nargs=1 -complete=customlist,s:FileCompletion StartPyclewn :call s:StartDebugging("<args>")

function! s:GetAllConfigsInPath(path, prefix)
	let l:configFiles = []
	for l:file in split(globpath(a:path, a:prefix . '*.cfg'), '\n')
		call add(l:configFiles, fnamemodify(l:file, ':t:r'))
	endfor
	return l:configFiles
endfunction

function! s:FileCompletion(ArgLead, CmdLine, CursorPos)
	return s:GetAllConfigsInPath(expand('~/.vim/pyclewn_configs/'), a:ArgLead)
endfunction

function! s:ReplacePrefix(value, prefix, replacement)
	return substitute(a:value, a:prefix, a:replacement, '')
endfunction

function! s:SectionExists(ini, section)
	 if !has_key(a:ini, a:section)
		 return 0
	 endif
	 return 1
endfunction

function! s:ParameterExists(ini, section, parameter)
	 if !s:SectionExists(a:ini, a:section)
		 return 0
	 endif
	 if !has_key(a:ini[a:section], a:parameter)
		 return 0
	 endif
	 return 1
endfunction

function! s:StartDebugging(configName)
	 let l:path = expand('~/.vim/pyclewn_configs/') . a:configName . '.cfg'
	 let l:ini = IniParser#Read(l:path)

	 if s:ParameterExists(l:ini, 'optional', 'gdb_path')
		 execute ':let b:pyclewn_args.=" --pgm=' . s:ReplacePrefix(l:ini['optional']['gdb_path'], '<prefix>', '/repo/sw') . '"'
	 endif

	 if exists(':Cexitclewn')
		 execute ':Cexitclewn'
	 endif

	 if exists(':Cunmapkeys')
		 execute ':Cunmapkeys'
	 endif

	 execute ':Pyclewn'
	 execute ':Cfile ' . s:ReplacePrefix(l:ini['mandatory']['executable'], '<prefix>', '/repo/sw')

	 if s:ParameterExists(l:ini, 'optional', 'sysroot')
		 execute ':Cset sysroot ' . s:ReplacePrefix(l:ini['optional']['sysroot'], '<prefix>', '/repo/sw')
	 endif

	 if s:ParameterExists(l:ini, 'optional', 'remote_target')
		 execute ':Ctarget remote ' . l:ini['optional']['remote_target']
	 endif

	 if s:SectionExists(l:ini, 'breaks')
		 for l:break in keys(l:ini['breaks'])
			 execute ':Cbreak ' . l:break
		 endfor
	 endif

	 if s:SectionExists(l:ini, 'extra_commands')
		 for l:command in keys(l:ini['extra_commands'])
			 execute l:command
		 endfor
	 endif

	 execute ':Cmapkeys'
endfunction

