-- === 底部状态栏 ===
if vim.g.vscode then return end

local P = {
	name = "lualine.nvim",
	deps = {
		"nvim-tree/nvim-web-devicons",
	},
}

-- 将 Lualine 的配置逻辑封装成一个独立函数，方便重复调用
local function setup_lualine_with_blend()
	-- 确保 lualine 已经加载，如果没有加载则不执行（防止 ColorScheme 先于插件加载触发报错）
	local has_lualine, lualine = pcall(require, "lualine")
	if not has_lualine then return end

	-- ==================== 【动态融合逻辑】 ====================
	local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	local editor_bg = normal_hl.bg and string.format("#%06x", normal_hl.bg) or "NONE"

	-- 每次需要重新 require('lualine.themes.auto') 来获取基于新主题生成的颜色
	package.loaded["lualine.themes.auto"] = nil
	local blended_theme = require("lualine.themes.auto")

	for _, mode in pairs(blended_theme) do
		for _, section in pairs(mode) do
			if type(section) == "table" then
				section.bg = editor_bg
			end
		end
	end

	lualine.setup({
		options = {
			theme = blended_theme,
			globalstatus = true,
			always_divide_middle = false,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = {},
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { { "lsp_status", color = { fg = "#6C6E81" } } },
			lualine_x = {},
			lualine_y = {},
			lualine_z = { "progress" },
		},
	})
end

-- 懒加载触发器 (只负责初次加载)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	once = true,   -- 只需要触发一次来加载插件
	callback = function()
		PackUtils.load(P, function()
			setup_lualine_with_blend()
		end)
	end
})

-- 主题切换触发器 (负责在主题改变时刷新)
vim.api.nvim_create_autocmd("ColorScheme", {
	-- 防止配置堆叠
	group = vim.api.nvim_create_augroup("LualineSync", { clear = true }),
	callback = function()
		-- 如果插件已经加载了，就重新应用配置
		setup_lualine_with_blend()
	end
})
