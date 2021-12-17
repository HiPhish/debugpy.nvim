let s:save_cpo = &cpo
set cpo&vim

function! debugpy#configure(subcmd, ...)
	let l:Configure = luaeval('require("debugpy").configure')
	return call(l:Configure, [a:subcmd] + a:000)
endfunction

function! debugpy#run(config)
	let l:Run = luaeval('require("debugpy").run')
	call l:Run(a:config)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
