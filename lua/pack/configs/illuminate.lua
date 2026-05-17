-- === 高亮当前文件所有引用 ===
if vim.g.vscode then return end

vim.keymap.set(
	"n",
	"g=",
	"<cmd>lua require('illuminate').goto_next_reference(true)<cr>",
	{ noremap = true, silent = true, desc = "Go to next reference" }
)
-- 将光标移动到上一个引用
vim.keymap.set(
	"n",
	"g-",
	"<cmd>lua require('illuminate').goto_prev_reference(true)<cr>",
	{ noremap = true, silent = true, desc = "Go to previous reference" }
)
