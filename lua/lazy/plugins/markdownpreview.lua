-- ===
-- === markdown preview
-- ===

return {
	"iamcco/markdown-preview.nvim",
	build = "cd app && npm install",
	init = function() vim.g.mkdp_filetypes = { "markdown" } end,
	ft = { "markdown" },
	lazy = true,
	config = function()
		-- 设置使用谷歌浏览器进行预览
		vim.g.mkdp_browser = '/usr/bin/google-chrome-stable'
	end
}

