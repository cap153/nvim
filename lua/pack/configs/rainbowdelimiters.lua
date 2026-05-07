-- === 彩虹括号 ===
local P = {
	name = "rainbow-delimiters.nvim",
}

-- 懒加载触发器
vim.api.nvim_create_autocmd({
	"FileType",
}, {
	once = true,
	callback = function()
			PackUtils.load(P, function()
				vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = "#56B6C2" })
				require("rainbow-delimiters.setup").setup({
					highlight = {
						'RainbowDelimiterBlue',
						'RainbowDelimiterViolet',
						'RainbowDelimiterRed',
						'RainbowDelimiterYellow',
						'RainbowDelimiterGreen',
						'RainbowDelimiterOrange',
						'RainbowDelimiterCyan',
					},
				})
			end)
	end
})
