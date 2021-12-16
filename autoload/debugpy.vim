let s:save_cpo = &cpo
set cpo&vim


" The backbone of the plugin, this function picks the configuration and
" invokes the DAP plugin.
function! debugpy#run(...) abort
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

	" Try the Lua dispatch table first
	let l:entry = luaeval('require("debugpy").subcommand[_A]', s:cmd)
	if l:entry is v:null
		let l:entry = get(get(g:, 'debugpy_subcommand', {}), s:cmd, v:null)
	endif
	if l:entry is v:null
		call s:err(' Debugpy: invalid subcommand ' .. s:cmd)
		return
	endif


	let [l:Configure, l:minargs] = [entry.configure, entry.arity.min]
	if len(s:args) < l:minargs
		call s:err(printf('Debugpy: %s: not enough arguments, needs at least %d, got %d', s:cmd, l:minargs, len(s:args)))
		return
	elseif has_key(l:entry.arity, 'max') && len(s:args) > l:entry.arity.max
		let l:maxargs = l:entry.arity.max
		call s:err(printf('Debugpy: %s: too many arguments, needs at most %d, got %d', s:cmd, l:maxargs, len(s:args)))
		return
	endif

	let l:config = call(l:Configure, s:args)
	call luaeval('require("dap").run(_A)', l:config)
endfunction


" Shortcut, save the last invocation here so we can re-call it if no arguments
" are given to the main command.
let s:cmd  = ''
let s:args = []

function! s:err(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
