local M = {}

M.state = {}

function M.backup_selection(bufnr, start_pos, end_pos)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, start_pos[1] - 1, end_pos[1], false)
	if start_pos[2] > 0 or end_pos[2] > 0 then
		lines[1] = lines[1]:sub(start_pos[2] + 1)
		lines[#lines] = lines[#lines]:sub(1, -end_pos[2])
	end
	return lines
end

function M.show_preview(bufnr, start_pos, end_pos, new_lines)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	M.state.backup = {
		bufnr = bufnr,
		start = start_pos,
		end_ = end_pos,
		lines = M.backup_selection(bufnr, start_pos, end_pos),
	}

	vim.api.nvim_buf_set_lines(bufnr, start_pos[1] - 1, end_pos[1], false, new_lines)

	vim.api.nvim_buf_set_extmark(bufnr, require("neural.ui").ns, start_pos[1] - 1, 0, {
		end_row = start_pos[1] + #new_lines - 1,
		hl_group = "DiffAdd",
		priority = 100,
	})
end

function M.accept()
	if not M.state.backup then
		return
	end

	local ns = require("neural.ui").ns
	vim.api.nvim_buf_clear_namespace(M.state.backup.bufnr, ns, 0, -1)
	M.state.backup = nil
end

function M.decline()
	if not M.state.backup then
		return
	end

	local ns = require("neural.ui").ns
	vim.api.nvim_buf_clear_namespace(M.state.backup.bufnr, ns, 0, -1)
	vim.api.nvim_buf_set_lines(
		M.state.backup.bufnr,
		M.state.backup.start[1] - 1,
		M.state.backup.end_[1],
		false,
		M.state.backup.lines
	)
	M.state.backup = nil
end

return M