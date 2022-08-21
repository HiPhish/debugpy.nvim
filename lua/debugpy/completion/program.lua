local function complete_program(args, pending)
	if #args > 1 or (#args == 1 and not pending) then
		return {}
	end
	local result = vim.fn.getcompletion(args[1] or '', 'file')
	for i, v in ipairs(result) do
		result[i] = vim.fn.escape(v, ' \\')
	end
	return result
end
