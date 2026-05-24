# neural.nvim

A Neovim plugin for working with local LLMs (like LM Studio). Select code, ask questions, and get inline preview with accept/decline.

## Features

- Visual selection to ask LLM
- Floating input window
- Inline diff preview with highlight
- y/n accept/decline workflow

## Setup

```lua
require("neural").setup({
  url = "http://localhost:1234/v1/chat/completions",
  auth_token = nil,  -- optional
  model = nil,       -- optional
  max_tokens = 2048,
  temperature = 0.7,
})
```

## Usage

1. Visually select code
2. Press `<leader>la`
3. Type your question in the floating input window
4. Press Enter to send
5. View the preview (highlighted in DiffAdd)
6. Press `y` to accept or `n`/`q` to decline

## Requirements

- curl (for HTTP requests)
- Local LLM server (e.g., LM Studio) at configured URL