let s:save_cpo = &cpo
set cpo&vim

function! debugpy#configure(subcmd, ...)
	return luaeval('require("debugpy").configure(_A[1], unpack(_A[2]))', [a:subcmd, a:000])
endfunction

function! debugpy#run(config)
	call luaeval('require("debugpy").run(_A)', a:config)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
