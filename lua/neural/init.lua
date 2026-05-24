local M = {}

local config = require("neural.config")
local http = require("neural.http")
local ui = require("neural.ui")
local diff = require("neural.diff")

function M.setup(opts)
	config.defaults = vim.tbl_deep_extend("force", config.defaults, opts or {})
end

function M.get_visual_selection()
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[2] - 1, end_pos[2], false)

	if #lines == 0 then
		return "", { start_pos, end_pos }
	end

	if #lines == 1 then
		lines[1] = lines[1]:sub(start_pos[3] + 1, end_pos[3])
	else
		lines[1] = lines[1]:sub(start_pos[3] + 1)
		lines[#lines] = lines[#lines]:sub(1, -end_pos[3] - 1)
	end

	return table.concat(lines, "\n"), { start_pos, end_pos }
end

function M.ask(prompt, code)
	local messages = {
		{ role = "system", content = "You are a helpful coding assistant. Provide only the modified code without explanations unless asked." },
		{ role = "user", content = prompt .. "\n\n```\n" .. code .. "\n```" },
	}

	local response, err = http.request(messages)
	if err then
		vim.notify("Neural: " .. err, vim.log.levels.ERROR)
		return
	end

	return response
end

function M.ask_selection()
	local code, positions = M.get_visual_selection()
	if not code or #code == 0 then
		vim.notify("Neural: No selection found", vim.log.levels.WARN)
		return
	end

	ui.open_input(function(prompt)
		local response = M.ask(prompt, code)
		if not response then
			return
		end

		local lines = vim.split(response, "\n")
		diff.show_preview(vim.api.nvim_get_current_buf(), positions[1], positions[2], lines)
		ui.show_accept_decline(vim.api.nvim_get_current_buf())
	end)
end

return M