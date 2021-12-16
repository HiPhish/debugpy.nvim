local has_dap, dap = pcall(require, 'dap')
if not has_dap then
	vim.cmd 'echohl Error'
	print 'Debugpy: Plugin nvim-dap not available; see https://github.com/mfussenegger/nvim-dap'
	vim.cmd 'echohl None'
	return
end

local debugpy = require 'debugpy'

for kind, config in pairs(debugpy.adapter) do
	local name = 'debugpy_' .. kind
	if not dap.adapters[name] then dap.adapters[name] = config end
end
