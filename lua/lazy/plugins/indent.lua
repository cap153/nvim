return {
	"shellRaining/hlchunk.nvim",
	-- 确保这个插件在lsp之后加载，不然会显示为蓝色的线
	event = "VeryLazy",
	config = function()
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, { pattern = "*", command = "EnableHL", })
		require('hlchunk').setup({
			chunk = {
				enable = true,
				use_treesitter = true,
				style = {
					{ fg = "#806d9c" },
				},
			},
			indent = {
				chars = { "│", "¦", "┆", "┊", },
				use_treesitter = false,
			},
			-- 不显示缩进空白处的点点
			blank = {
				enable = false,
			},
			-- 让左侧数字高亮
			line_num = {
				use_treesitter = true,
			},
		})
	end
}
