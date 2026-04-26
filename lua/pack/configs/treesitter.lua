if vim.g.vscode then return end

local P = {
	name = "nvim-treesitter",
	build_cmd = ":TSUpdate",
}

PackUtils.setup_listener(P.name, P.build_cmd)

-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local ensure_installed = {
	"json",
	"rust",
	"python",
	"lua",
	"markdown",
	"sh",
	"java",
}

-- 在 FileType 确定时，检查、安装并启动
vim.api.nvim_create_autocmd("FileType", {
  pattern = ensure_installed,
	group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype
		-- 过滤无效 buffer, 终端, 以及 yazi
		if ft == "" or ft == "yazi" or vim.bo[buf].buftype ~= "" then return end
		-- 过滤大型文件 (大于 100KB 不开启 Treesitter，防止卡顿)
		local max_filesize = 100 * 1024
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
		if ok and stats and stats.size > max_filesize then return end
		-- 获取标准化的 Parser 名称
		local lang = vim.treesitter.language.get_lang(ft) or ft
		-- 检查该语言是否在我们的配置列表中
		if vim.tbl_contains(ensure_installed, lang) then
			local no_err, is_added = pcall(vim.treesitter.language.add, lang)
			if not no_err or not is_added then
				-- 只有在需要安装时，才把 nvim-treesitter 插件加载进内存
				PackUtils.load(P, function() end)
				vim.notify("🌱 Installing " .. lang .. " parser...", vim.log.levels.INFO)
				local ts = require("nvim-treesitter")
				if ts.install then
					ts.install({ lang }):wait(60000)
				else
					vim.cmd("TSInstall " .. lang)
				end
			end
			-- 万事俱备，启动高亮
			pcall(vim.treesitter.start, buf, lang)
		end
	end,
})
