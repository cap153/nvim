-- === 对字符自动补全另一半 ===
if vim.g.vscode then return end

local P = {
	name = "nvim-autopairs", -- 仓库名
}

-- 懒加载触发器
vim.api.nvim_create_autocmd({
	"InsertEnter"
}, {
	once = true,
	callback = function()
		PackUtils.load(P, function()
			require('nvim-autopairs').setup({
				-- 在写markdown时禁用括号补全
				disable_filetype = { "markdown" },
				-- can use treesitter to check for a pair.
				check_ts = true,
			})
		end)
	end
})
