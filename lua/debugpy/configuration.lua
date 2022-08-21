--Table of configurations, each key is the name of the corresponding
--subcommand.
local M = {}

local base_config = {
	type = 'debugpy_executable',
	request = 'launch',
}

--Helper function, enriches the given configuration with the default
--configuration.
--
--- @param config table  Configuration settings
--- @return table config  Final configuration
local function make_config(config)
	return vim.tbl_extend('keep', config, base_config)
end

--Configuration for debugging a Python module.
--- @param module string  Module path in Python's dot-notation
function M.module(module, ...)
	return make_config {
		name = string.format('Python module \'%s\'', module),
		module = module,
		args = {...}
	}
end

--Configuration for debugging a Python script.
--- @param path string  Path to the script
function M.program(path, ...)
	return make_config {
		name = string.format('Python program \'%s\'', path),
		program = path or '${file}',
		args = {...},
	}
end

--Configuration for debugging a Python code snippet.
--- @param snippet string  Python code snippet to debug
function M.code(snippet)
	return {
		type = 'debugpy_executable',
		name = 'Python code snippet',
		request = 'launch',
		code = snippet
	}
end

--Configuration for attaching to a running Python process.
--- @param host string         IP of the machine where the process is running
--- @param port string|number  Port on which the running program is listening
function M.attach(host, port)
	return make_config {
		type = 'debugpy_server',
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

return M
