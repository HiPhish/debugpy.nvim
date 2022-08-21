---Public interface to the Debugpy frontend; you can overwrite the entries of
---this table to customize the behaviour.
local M = {}
local dap = require 'dap'
local config = require 'debugpy.configuration'

---Dispatch table, maps a subcommand to its specification.
M.subcommand = {
	module = {
		arity = {min = 1},
		configure = config.module,
		complete = require 'debugpy.completion.module',
	},
	program = {
		configure = config.program,
		complete = require 'debugpy.completion.program'
	},
	code = {
		arity = {min = 1, max = 1},
		configure = config.code,
	},
	attach = {
		arity = {min = 2, max = 2},
		configure = config.attach,
	},
	-- Disbled for now; it would be better to support the launch.json file from
	-- VSCode
	--
	-- json = {
	-- 	arity = {min = 1, max = 2},
	-- 	configure = function(path, key)
	-- 		local json = vim.fn.json_decode(vim.fn.readfile(path))
	-- 		return key and json[key] or json
	-- 	end
	-- },
}

M.adapter = {
	executable = {
		type = 'executable',
		command = vim.fn.executable('python3') ~= 0 and 'python3' or 'python',
		args = {'-m', 'debugpy.adapter'}
	},
	server = function(callback, server_config)
		callback {
			type = 'server',
			host = server_config.host,
			port = server_config.port,
		}
	end
}

---Function to run the debugger with a complete configuration. The default
---implementation calls `dap.run`.
function M.run(final_config)
	dap.run(final_config)
end

function M.configure(subcommand, ...)
	local entry = M.subcommand[subcommand]
		or vim.g.debugpy_subcommand[subcommand]

	if not entry then
		error(string.format('Debugpy: invalid subcommand %s', subcommand))
	end

	local args = {...}
	local arity = entry.arity or {}
	local min_args, max_args = arity.min or 0, arity.max
	if #args < min_args then
		error(string.format(
			'Debugpy: %s: not enough arguments, needs at least %d, got %d',
			subcommand, min_args, #args))
	end

	if max_args and #args > max_args then
		error(string.format(
			'Debugpy: %s: too many arguments, needs at most %d, got %d',
			subcommand, max_args, #args))
	end

	return entry.configure(...)
end

return M
