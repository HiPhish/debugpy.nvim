--Internal helper module, implements completion for 'module' subcommand
local fn = vim.fn

--Completes an absolute Python module path.
--
--- @param args    string   Module path in dot notation, may be incomplete
--- @param pending boolean  Whether the current argument is still incomplete
--- @return string[] candidates  Completion candidates
local function complete_module(args, pending)
	if #args > 1 or (#args == 1 and not pending) then
		return {}
	end

	--The argument we want to complete
	local arg = args[1] or ''
	--Leading portion of the argument, everything before the last period
	local head = fn.substitute(arg, '\\v\\.[^.]*$', '', '')
	--The argument as a path string
	local path = fn.substitute(arg, '\\v\\.', '/', 'g')
	--Whether the argument contains any period character at all
	local has_dot = fn.stridx(arg, '.') > -1

	local module_glob = fn.printf('%s*.py', path)
	local package_glob = fn.printf('%s*/__init__.py', path)

	local module_candidates = fn.glob(module_glob, false, true)
	local package_candidates = fn.glob(package_glob, false, true)

	-- For each module candidate drop its path and extension
	for i, module in ipairs(module_candidates) do
		local name = fn.fnamemodify(module, ':t:r')
		if not has_dot then
			module_candidates[i] = name
		else
			module_candidates[i] = head .. '.' .. name
		end
	end
	-- For each package candidate drop its file and then the leading path
	for i, package in ipairs(package_candidates) do
		local name = fn.fnamemodify(package, ':h:t')
		-- if #parts == 0 then
		if not has_dot then
			package_candidates[i] = name
		else
			package_candidates[i] = head .. '.' .. name
		end
	end

	return fn.sort(fn.extend(module_candidates, package_candidates))
end

return complete_module
