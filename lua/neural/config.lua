local M = {}

M.defaults = {
	url = "http://localhost:1234/v1/chat/completions",
	auth_token = nil,
	model = nil,
	max_tokens = 2048,
	temperature = 0.7,
	timeout = 30000,
}

return M