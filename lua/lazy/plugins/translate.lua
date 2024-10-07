-- 可视视图下
return {
	"kraftwerk28/gtranslate.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		vim.api.nvim_set_keymap('n', 'tr', "viw:'<,'>Translate<CR>", { noremap = true, silent = true })
		vim.api.nvim_set_keymap('v', 'tr', ":'<,'>Translate<CR>", { noremap = true, silent = true })
		require("gtranslate").setup {
			default_to_language = "Chinese_Simplified",
		}
	end
}

