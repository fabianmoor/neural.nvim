-- lua/nerual/init.lua
local M = {}

M.config = {
	option_one = true,
	greeting = "hello",
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	-- initialization logic here
end

return M
