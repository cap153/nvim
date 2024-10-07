-- ===
-- === outlines,大纲,函数变量结构
-- ===

local map = require("core.keymap")
-- 空格+v打开大纲,N全部收起,n收起当前节点,r重命名,I展开全部节点,i展开当前节点
map:cmd('<space>v', 'SymbolsOutline')

return {
	'simrat39/symbols-outline.nvim',
	config = function()
		require("symbols-outline").setup {
			width = 20,
			keymaps = { -- These keymaps can be a string or a table for multiple keys
				close = {"<Esc>", "q"},
				goto_location = "<Cr>",
				focus_location = "o",
				hover_symbol = "<C-space>",
				toggle_preview = "K",
				rename_symbol = "r",
				code_actions = "a",
				fold = "n",
				unfold = "i",
				fold_all = "N",
				unfold_all = "I",
				fold_reset = "R",
			}
		}
	end
}
