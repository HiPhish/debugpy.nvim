-- Health check implementation for debugpy.nvim
local M = {}

local health = require 'health'
local command = require('debugpy').adapter.executable.command

local function check_dap()
	local success = pcall(require, 'dap')

	if success then
		health.report_ok "Plugin 'nvim-dap' found"
	else
		health.report_error "Plugin 'nvim-dap' not found"
		health.report_info 'Official nvim-dap website: https://github.com/mfussenegger/nvim-dap'
	end

	return success
end

local function check_python()
	local success = vim.fn.executable(command) ~= 0
	if success then
		health.report_ok(string.format("Executable '%s' found", command))
	else
		health.report_error(string.format("Executable '%s' not found", command))
		health.report_warn 'Skipping check for debugpy module'
		health.report_info 'See debugpy.adapter.executable on how to set your Python executable'
		return
	end
	return success
end

local function check_debugpy()
	-- Note: this might not work on old versions of Python, tested with 3.10;
	-- the goal is to check for the presence of a module without actually
	-- importing it (for security, just in case).
	vim.fn.system {
		command,
		'-c',
		'from importlib.util import find_spec as fs; exit(0 if fs("debugpy") else 1)'
	}
	if vim.v.shell_error == 0 then
		health.report_ok "Python module 'debugpy' found"
	else
		health.report_error "Python module 'debugpy' not found"
		health.report_info 'Official debugpy website: https://github.com/microsoft/debugpy'
	end
end

function M.check()
	health.report_start 'Debugpy.nvim'

	check_dap()
	check_python()
	check_debugpy()
end

return M
