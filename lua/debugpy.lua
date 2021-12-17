---Public interface to the Debugpy frontend; you can overwrite the entries of
---this table to customize the behaviour.
local M = {}
local dap = require 'dap'

local base_config = {
	type = 'debugpy_executable',
	request = 'launch',
}

local function make_config(config)
	return vim.tbl_extend('keep', config, base_config)
end

---Dispatch table, maps a subcommand to its specification.
M.subcommand = {
	module = {
		arity = {min = 1},
		configure = function(module, ...)
			return make_config {
				name = string.format('Python module \'%s\'', module),
				module = module,
				args = {...}
			}
		end,
	},
	program = {
		arity = {min = 0},
		configure = function(program, ...)
			return make_config {
				name = string.format('Python program \'%s\'', program),
				program = program or '${file}',
				args = {...},
			}
		end,
	},
	attach = {
		arity = {min = 2, max = 2},
		configure = function(host, port)
			return make_config {
				type = 'debugpy_server',
				-- type = 'debugpy_executable',
				name = string.format('Remote process at \'%s@%s\'', host, port),
				request = 'attach',
				host = host,
				port = port + 0,  -- Coerce to number
				-- Maps between local and remote working directories
				pathMappings = {
					{  -- Map Neovim working directory to debuggee working directory
						localRoot = '${workspaceFolder}',
						remoteRoot = '.'
					}
				},
			}
		end
	},
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
	local min_args, max_args = entry.arity.min, entry.arity.max
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
