if vim.g.loaded_neural then
	return
end
vim.g.loaded_neural = true

vim.api.nvim_create_user_command("NeuralAsk", function()
	require("neural").ask_selection()
end, { range = true })

vim.keymap.set("v", "<leader>la", function()
	require("neural").ask_selection()
end, { desc = "Ask LLM about selection" })