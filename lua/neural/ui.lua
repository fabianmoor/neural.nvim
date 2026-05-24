local M = {}

M.ns = vim.api.nvim_create_namespace("neural")

local input_buf, input_win

function M.open_input(callback)
	local width = math.floor(vim.o.columns * 0.6)
	local height = 3

	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	input_buf = vim.api.nvim_create_buf(false, true)

	input_win = vim.api.nvim_open_win(input_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Ask LLM (Ctrl+C to cancel) ",
		title_pos = "center",
	})

	vim.bo[input_buf].buftype = "nofile"
	vim.bo[input_buf].bufhidden = "wipe"

	vim.bo[input_buf].modified = false

	vim.api.nvim_buf_set_lines(input_buf, 0, 1, false, { "" })

	vim.bo[input_buf].textwidth = width - 2

	vim.keymap.set("i", "<CR>", function()
		local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
		local prompt = table.concat(lines, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
		vim.api.nvim_win_close(input_win, true)
		input_buf, input_win = nil, nil
		if prompt and #prompt > 0 and callback then
			callback(prompt)
		end
	end, { buffer = input_buf, silent = true })

	vim.keymap.set("i", "<C-c>", function()
		vim.api.nvim_win_close(input_win, true)
		input_buf, input_win = nil, nil
		vim.cmd("echo 'Cancelled'")
	end, { buffer = input_buf, silent = true })
end

function M.show_accept_decline(bufnr)
	local opts = { buffer = bufnr }
	vim.keymap.set("n", "y", function()
		require("neural.diff").accept()
	end, opts)
	vim.keymap.set("n", "n", function()
		require("neural.diff").decline()
	end, opts)
	vim.keymap.set("n", "q", function()
		require("neural.diff").decline()
	end, opts)
end

return M