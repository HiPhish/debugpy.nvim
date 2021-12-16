if get(g:, 'loaded_debugpy', v:false)
	finish
endif
let s:save_cpo = &cpo
set cpo&vim
let g:debugpy_loaded = v:true

if !has_key(g:, 'debugpy_subcommand')
	let g:debugpy_subcommand = {}
endif

command! -nargs=* -complete=customlist,<SID>complete Debugpy call debugpy#run(<f-args>)

function! s:complete(arg_lead, cmd_line, cursor_pos)
	" Abort if the sub-command has been completed (more than two arguments).
	" Special case when the command line has two arguments and ends with
	" whitespace: second argument has been completed
	let l:nargs = len(split(a:cmd_line, '\v[^\\](\\\\)*\zs\s+'))
	if l:nargs > 2 || l:nargs == 2 && a:cmd_line[-1:] =~? '\v\s'
		return []
	endif

	let l:keys = extend(
		\ luaeval('vim.tbl_keys(require("debugpy").subcommand)'),
		\ keys(get(g:, 'debugpy_subcommand', {})),
		\ 'keep')
	return sort(filter(keys, {_,v -> match(v, '\v^' .. a:arg_lead) >= 0}))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
