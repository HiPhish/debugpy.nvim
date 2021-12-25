if get(g:, 'loaded_debugpy', v:false)
	finish
endif
let s:save_cpo = &cpo
set cpo&vim
let g:debugpy_loaded = v:true

if !has_key(g:, 'debugpy_subcommand')
	let g:debugpy_subcommand = {}
endif

command! -nargs=* -complete=customlist,<SID>complete Debugpy call s:debugpy(<f-args>)

" Shortcut, save the last invocation here so we can re-call it if no arguments
" are given to the main command.
let s:cmd  = ''
let s:args = []

" The backbone of the plugin, this function picks the configuration and
" invokes the DAP plugin.
function! s:debugpy(...) abort
	" If no arguments are given we repeat the previous invocation; if there
	" was no previous invocation we display an error.
	if a:0 == 0
		if empty(s:cmd)
			call s:err('Debugpy: at least one argument needed')
			return
		endif
	else
		let s:cmd  = a:1
		let s:args = a:000[1:]
	endif

	try
		let l:config = call(function('debugpy#configure'), [s:cmd] + s:args)
	catch /\vDebugpy: /
		" Lua inserts a stack trace into the message; we have to extract the
		" message again
		call s:err(matchstr(split(v:exception, "\n")[0], '\vDebugpy: .*'))
		return
	endtry

	call debugpy#run(l:config)
endfunction

function! s:complete(arg_lead, cmd_line, cursor_pos)
	" Abort if the sub-command has been completed (more than two arguments).
	" Special case when the command line has two arguments and ends with
	" whitespace: second argument has been completed
	let l:args = split(a:cmd_line, '\v[^\\](\\\\)*\zs\s+')
	let l:nargs = len(l:args)

	" The command has been completed, but the subcommand is still being
	" written
	if l:nargs < 2 || l:nargs == 2 && a:cmd_line[-1:] !~? '\v\s'
		let l:keys = extend(
			\ luaeval('vim.tbl_keys(require("debugpy").subcommand)'),
			\ keys(get(g:, 'debugpy_subcommand', {})),
			\ 'keep')
		return sort(filter(keys, {_,v -> match(v, '\v^' .. a:arg_lead) >= 0}))
	endif

	" The subcommand has been completed, delegate to its completion function
	" if it exists
	let l:subcmd = s:get_subcmd(l:args[1])
	let l:Complete = get(l:subcmd, 'complete', v:null)
	if l:Complete is v:null
		return []
	endif

	return l:Complete(l:args[2:], a:cmd_line[-1:] !~? '\v\s' ? v:true : v:false)
endfunction

function! s:err(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction


" Look up a subcommand object in Lua and Vim script, return first one found
function! s:get_subcmd(name)
	let l:result = luaeval('require("debugpy").subcommand[_A]', a:name)

	if l:result is v:null
		let l:result = get(g:debugpy_subcommand, a:name, v:null)
	endif

	return l:result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
