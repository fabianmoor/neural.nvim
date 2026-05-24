local M = {}
local config = require("neural.config")

function M.request(messages, opts)
	opts = opts or {}
	local cfg = vim.tbl_extend("force", config.defaults, opts)

	local body = {
		messages = messages,
		max_tokens = cfg.max_tokens,
		temperature = cfg.temperature,
		stream = false,
	}
	if cfg.model then
		body.model = cfg.model
	end

	local json_body = vim.fn.json_encode(body)

	local curl_args = { "curl", "-s", "-X", "POST", "-H", "Content-Type: application/json", "-d", json_body }

	if cfg.auth_token then
		table.insert(curl_args, "-H")
		table.insert(curl_args, "Authorization: Bearer " .. cfg.auth_token)
	end
	table.insert(curl_args, cfg.url)

	local result = vim.fn.system(curl_args, cfg.timeout / 1000)

	local ok, response = pcall(vim.fn.json_decode, result)
	if not ok then
		return nil, "Failed to decode response: " .. result
	end

	if response.error then
		return nil, response.error.message or "Unknown error"
	end

	return response.choices[1].message.content, nil
end

return M