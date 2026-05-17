-- === 代码格式化 (conform.nvim) ===
if vim.g.vscode then return end

local P = {
	name = "conform.nvim",
	deps = {
		"mason.nvim",
		"mason-registry",
	},
}

-- 提取出统一的配置变量
local formatters_by_ft = {
	python = { "isort", "black" },
	rust = { "rustfmt", lsp_format = "fallback" },
	toml = { "templ" },
	sh = { "shfmt" },
	zsh = { "shfmt" },
	xml = { "deno_fmt" },
	yml = { "deno_fmt" },
	yaml = { "deno_fmt" },
	html = { "deno_fmt" },
	typescript = { "deno_fmt" },
	javascript = { "deno_fmt" },
	json = { "deno_fmt" },
	-- markdown = { "deno_fmt_markdown" },
}

local real_executable_map = {
	deno_fmt = "deno",
	deno_fmt_markdown = "deno",
}

-- 辅助函数：从指定文件类型的配置中提取所有工具名称（去重）
local function get_ensure_installed_for_ft(ft, ft_table)
	local tools = {}
	local cfg = ft_table[ft]
	if type(cfg) == "table" then
		for _, item in ipairs(cfg) do
			if type(item) == "string" then
				tools[item] = true
			end
		end
	elseif type(cfg) == "string" then
		tools[cfg] = true
	end
	local list = {}
	for tool, _ in pairs(tools) do
		table.insert(list, tool)
	end
	return list
end

-- 快捷键纯懒加载：只在按下快捷键时激活
vim.keymap.set({ "n", "x" }, "<leader>f", function()
	PackUtils.load(P, function()
		require("conform").setup({ -- At a minimum, you will need to set up some formatters by filetype
			formatters_by_ft = formatters_by_ft,
			formatters = {
				deno_fmt_markdown = {
					inherit = "deno_fmt", -- 继承格式化程序
					append_args = { "--indent-width", "4" },
				}
			},
		}
		)
	end)
	local ft = vim.bo.filetype
	local raw_tools = get_ensure_installed_for_ft(ft, formatters_by_ft)
	local need_install = false
	for _, raw_tool in ipairs(raw_tools) do
		local real_tool = real_executable_map[raw_tool] or raw_tool
		if vim.fn.executable(real_tool) == 0 then
			need_install = true
			local registry = require("mason-registry")
			if not registry.is_installed(real_tool) then
				vim.notify("⬇️ Installing formatter: " .. real_tool, vim.log.levels.INFO)
				registry.get_package(real_tool):install()
			end
		end
	end
	if need_install then
		vim.notify("⏳ 格式化工具正在后台安装，请稍后重试...", vim.log.levels.WARN)
	else
		require("conform").format({ async = true, lsp_fallback = true })
	end
end, { desc = "格式化代码（检测安装缺失工具）" })
