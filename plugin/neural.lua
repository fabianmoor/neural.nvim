-- plugin/neural.lua
if vim.g.loaded_my_plugin then
	return
end
vim.g.loaded_my_plugin = true

vim.api.nvim_create_user_command("MyPluginHello", function()
	local plugin = require("my-plugin")
	print(plugin.config.greeting)
end, {})
